# frozen_string_literal: true

require_relative 'plugin'

module Durt
  class NotifyPlugin < Plugin
    def start(value)
      time_tracker.start(value)
    end

    def stop(value)
      time_tracker.stop(value)
    end

    def time_tracker_class
      Durt::NotifyTracker
    end
  end
end
