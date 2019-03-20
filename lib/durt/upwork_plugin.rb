# frozen_string_literal: true

module Durt
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
end
