# frozen_string_literal: true

module Durt
  class InternalPlugin < Plugin
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
      Durt::InternalBugTracker.new
    end

    private

    def prompt
      @prompt ||= TTY::Prompt.new
    end
  end
end
