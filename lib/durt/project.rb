# frozen_string_literal: true

module Durt
  class Project
    def self.current_project
      new
    end

    def plugins
      @plugins ||= Durt::Plugin.all
    end

    def bug_tracker_plugin
      plugins.find { |p| p.bug_tracker.active? }
    end

    def time_tracker_plugins
      plugins.find_all { |p| p.time_tracker.active? }
    end

    def issues
      bug_tracker_plugin.issues
    end

    def active_issue
      issues.find_by!(active: true)
    end
  end
end

