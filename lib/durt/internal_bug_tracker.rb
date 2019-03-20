# frozen_string_literal: true

require_relative 'bug_tracker'

module Durt
  class InternalBugTracker < BugTracker
    def fetch_issues
      issues
    end

    def fetch_statuses
      statuses
    end
  end
end
