# frozen_string_literal: true

require 'tty-prompt'

module Durt
  class Plugin
    # TODO: Remove this hardcoded plugin configs

    PLUGINS = [ 'Upwork', 'Internal', 'Jira', 'Ebs' ].freeze

    def self.all
      PLUGINS.map do |plugin_name|
        klass = "Durt::#{plugin_name}Plugin"

        klass.constantize.new
      end
    end

    def name
      self.class.name.split('::').last.sub('Plugin', '')
    end

    def filter
      nil
    end

    def before_pick
      nil
    end

    def pick
      return if issues.empty?

      prompt.select('What will you work on?', issues.to_choice_h).tap do |issue|
        puts "Selected: #{issue}\n"
      end
    end

    def before_enter(_issue)
      # system("#{command} issue.to_json or sth")
      nil
    end

    def enter(_issue)
      # system("#{command} issue.to_json or sth")
      nil
    end

    def start
      # system("#{command} issue.to_json or sth")
      nil
    end

    def stop
      # system("#{command} issue.to_json or sth")
      nil
    end

    def issues
      bug_tracker.issues
    end

    private

    def command
      # "durt-#{config[:name]}" || config[:command]
    end

    def time_tracker
      TimeTracker.new
    end

    def bug_tracker
      BugTracker.new
    end

    attr_reader :config
  end

  class InternalPlugin < Plugin
    def enter(issue)
      time_tracker.enter(issue)
    end

    def start
      time_tracker.start
    end

    def stop
      time_tracker.stop
    end

    def time_tracker
      Durt::InternalTracker
    end

    def bug_tracker
      Durt::InternalBugTracker.new
    end

    private

    def prompt
      @prompt ||= TTY::Prompt.new
    end
  end

  class JiraPlugin < Plugin
    include Configurable

    def before_pick
      bug_tracker.fetch_issues
    end

    def filter
      message = 'Select the statuses that you want to include:'
      chosen_statuses = prompt.multi_select(message, statuses.to_choice_h)

      statuses.update_all(active: false)
      statuses.where(id: chosen_statuses).update_all(active: true)
    end

    def time_tracker
      nil
    end

    def bug_tracker
      raise NotConfiguredError unless config

      Durt::JiraBugTracker.new(config)
    end

    def config_key
      'Jira'
    end

    def statuses
      bug_tracker.statuses
    end

    private

    def prompt
      @prompt ||= TTY::Prompt.new
    end

    class NotConfiguredError < StandardError
    end
  end

  class UpworkPlugin < Plugin
    def enter(issue)
      time_tracker.enter(issue)
    end

    def start
      time_tracker.start
    end

    def stop
      time_tracker.stop
    end

    def time_tracker
      Durt::UpworkTracker
    end

    def bug_tracker
      nil
    end
  end

  class EbsPlugin < Plugin
    def before_enter(issue)
      edit_estimate(issue)
    end

    def edit_estimate(issue)
      estimate_input =
        prompt.ask('How long do you think this task will take you?')

      input_in_seconds = estimate_input_to_seconds(estimate_input)

      EstimateIssue.call(issue: issue, estimation: input_in_seconds)
      issue
    end

    private

    def estimate_input_to_seconds(input)
      digit = input.gsub(/[^\d\.]/, '').to_f
      measure_char = input.gsub(/[\d\.]/, '').strip.chr

      time_in_seconds = if measure_char == 's'
                          digit
                        elsif measure_char == 'm'
                          digit * 60
                        elsif measure_char == 'h'
                          digit * 3600
                        else
                          raise WhatKindOfTimeIsThatError
                        end

      time_in_seconds.ceil(2)
    end

    def prompt
      @prompt ||= TTY::Prompt.new
    end

    class EstimateIssue < ::Durt::Service
      def initialize(issue:, estimation:)
        @issue = issue
        @estimation = estimation
      end

      def call
        @issue.update(estimate: @estimation)

        plugins.each do |plugin|
          plugin.bug_tracker.estimate(@issue.key, @estimation)
        end
      end

      private

      def plugins
        valid_plugins = ['Jira']

        Durt::Project.current_project.plugins.find_all do |p|
          valid_plugins.include? p.name
        end
      end
    end
  end
end
