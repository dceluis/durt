# frozen_string_literal: true

require_relative 'plugin'

module Durt
  class LocalPlugin < Plugin
    def new_issue(issue_name)
      bug_tracker.new_issue(issue_name)
    end

    def bug_tracker_class
      Durt::LocalBugTracker
    end
  end
end
