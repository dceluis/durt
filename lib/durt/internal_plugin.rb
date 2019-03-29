# frozen_string_literal: true

require_relative 'plugin'

module Durt
  class InternalPlugin < Plugin
    def start(_value)
      time_tracker.start
    end

    def stop(_value)
      time_tracker.stop
    end

    def time_tracker_class
      Durt::InternalTracker
    end

    def bug_tracker_class
      Durt::InternalBugTracker
    end
  end
end
