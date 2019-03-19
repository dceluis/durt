# frozen_string_literal: true

module Durt
  class Plugin
    # TODO: Remove this hardcoded plugin configs

    PLUGINS = [
      { name: 'Upwork' },
      { name: 'Internal' },
      { name: 'Jira' }
    ].freeze

    def self.all
      PLUGINS.map do |plugin_conf|
        klass = "Durt::#{plugin_conf[:name]}Plugin"

        klass.constantize.new
      end
    end

    def enter(issue)
      # system("#{command} issue.to_json or sth")
    end

    private

    def command
      # "durt-#{config[:name]}" || config[:command]
    end

    def time_tracker
      raise NotImplementedError
    end

    def bug_tracker
      raise NotImplementedError
    end

    attr_reader :config
  end

  class InternalPlugin < Plugin
    def enter(issue)
      time_tracker.enter(issue)
    end

    def time_tracker
      Durt::InternalTracker
    end

    def bug_tracker
      nil
    end
  end

  class JiraPlugin < Plugin
    def time_tracker
      nil
    end

    def bug_tracker
      Durt::JiraBugTracker
    end
  end

  class UpworkPlugin < Plugin
    def enter(issue)
      time_tracker.enter(issue)
    end

    def time_tracker
      Durt::UpworkTracker
    end

    def bug_tracker
      nil
    end
  end
end
