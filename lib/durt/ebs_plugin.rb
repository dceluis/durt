# frozen_string_literal: true

module Durt
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
