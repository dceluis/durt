# frozen_string_literal: true

require 'tty-prompt'

module Durt
  class Plugin
    attr_reader :config

    PLUGINS = %w[Upwork Pivotal Jira Github Internal Ebs].freeze

    def self.all
      PLUGINS.map do |plugin_name|
        klass = "Durt::#{plugin_name}Plugin"

        klass.constantize
      end
    end

    def initialize(config = nil)
      @config = config
    end

    def self.find_by_plugin_name(plugin_name)
      all.find { |plugin| plugin.plugin_name == plugin_name.to_s }
    end

    def self.plugin_name
      name.split('::').last.sub('Plugin', '')
    end

    def self.demo_config
      nil
    end

    def filter
      nil
    end

    def before_choose
      nil
    end

    def plugin_name
      self.class.plugin_name
    end

    def choose
      return if issues.empty?

      prompt.select('What will you work on?', issues.to_choice_h).tap do |issue|
        puts "Selected: #{issue}\n"
        commit(issue)
      end
    end

    def commit(issue)
      issues.update_all(active: false)
      issue.reload.update(active: true)
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

    def command
      # "durt-#{config[:name]}" || config[:command]
    end

    def time_tracker
      time_tracker_class
    end

    def bug_tracker
      if config_required? && not_configured?
        raise NotConfiguredError, "#{plugin_name} plugin is not configured"
      end

      bug_tracker_class.new(@config)
    end

    private

    def config_required?
      false
    end

    def not_configured?
      @config == self.class.demo_config
    end

    def time_tracker_class
      Durt::NullTimeTracker
    end

    def bug_tracker_class
      Durt::NullBugTracker
    end

    def prompt
      @prompt ||= TTY::Prompt.new
    end

    class NotConfiguredError < StandardError
    end
  end
end
