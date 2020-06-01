# frozen_string_literal: true

require_relative 'bug_tracker'

module Durt
  class LocalBugTracker < BugTracker
    def new_issue(issue_name)
      {
        summary: issue_name,
        project: project,
        source: source_name
      }
    end

    def fetch_issues
      issues
    end

    def fetch_statuses
      statuses
    end
  end
end
