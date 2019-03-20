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

    # def bug_trackers
    #   plugins.find_all { |plugin| !plugin.bug_tracker.nil? }
    # end
    #
    # def time_trackers
    #   plugins.find_all { |plugin| !plugin.time_tracker.nil? }
    # end
  end
end

