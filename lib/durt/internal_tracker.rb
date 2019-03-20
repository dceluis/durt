# frozen_string_literal: true

require_relative 'time_tracker'

module Durt
  class InternalTracker < TimeTracker
    def self.enter(issue)
      # Already entered into time tracking when committing to internal bug
      # tracker
    end

    def self.start
      return if active_issue.tracking?

      active_issue.start_tracking!
    end

    def self.stop
      return unless active_issue.tracking?

      active_issue.stop_tracking!

      notify!
    end

    def self.notify!
      tracked_time = active_issue.sessions.last.tracked_time
      total = active_issue.total_tracked_time
      system("notify-send 'Minutes tracked: #{(tracked_time / 60).ceil}'")
      system("notify-send 'Minutes tracked overall: #{(total / 60).ceil}'")
    end

    def self.active_issue
      Durt::Project.current_project.active_issue
    end
  end
end
