# frozen_string_literal: true

require_relative 'plugin'

module Durt
  class UpworkPlugin < Plugin
    def enter(issue)
      time_tracker.enter(issue)
    end

    def start(_value)
      time_tracker.start
    end

    def stop(_value)
      time_tracker.stop
    end

    def time_tracker_class
      Durt::UpworkTracker
    end
  end
end
