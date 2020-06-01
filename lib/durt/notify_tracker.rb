# frozen_string_literal: true

require_relative 'time_tracker'

module Durt
  class NotifyTracker < TimeTracker
    def self.enter(issue); end

    def self.start(issue)
      notify!("Started tracking: #{issue.label}")
    end

    def self.stop(issue)
      tracked_time = issue.sessions.last.tracked_time
      total = issue.total_tracked_time

      notify!("Minutes tracked: #{(tracked_time / 60).ceil}")
      notify!("Minutes tracked overall: #{(total / 60).ceil}")
    end

    def self.notify!(message)
      system("notify-send '#{message}'")
    end
  end
end
