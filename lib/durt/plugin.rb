# frozen_string_literal: true

module Durt
  class Plugin
    # TODO: Remove this hardcoded plugin configs

    PLUGINS = [
      { name: 'Upwork' },
      { name: 'Internal' },
      { name: 'Jira' },
      { name: 'Ebs' }
    ].freeze

    def self.all
      PLUGINS.map do |plugin_conf|
        klass = "Durt::#{plugin_conf[:name]}Plugin"

        klass.constantize.new
      end
    end

    def before_pick
      nil
    end

    def pick
      nil
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
    def pick
      Durt::Prompt.new.pick_issue
    end

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
      nil
    end
  end

  class JiraPlugin < Plugin
    include Configurable

    def before_pick
      bug_tracker.fetch_issues
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
      Durt::Prompt.new.edit_estimate(issue)
    end
  end
end
