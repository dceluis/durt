# frozen_string_literal: true

require_relative 'plugin'

module Durt
  class InternalPlugin < Plugin
    def start
      time_tracker.start
    end

    def stop
      time_tracker.stop
    end

    def time_tracker_class
      Durt::InternalTracker
    end

    def bug_tracker_class
      Durt::InternalBugTracker
    end

    private

    def config_required?
      true
    end

    def prompt
      @prompt ||= TTY::Prompt.new
    end
  end
end
