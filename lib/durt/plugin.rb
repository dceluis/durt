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

    def before_choose
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
  end
end
