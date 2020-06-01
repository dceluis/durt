# frozen_string_literal: true

require_relative 'plugin'

module Durt
  class LocalPlugin < Plugin
    def bug_tracker_class
      Durt::LocalBugTracker
    end
  end
end
