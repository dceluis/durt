# frozen_string_literal: true

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
