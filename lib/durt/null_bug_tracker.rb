# frozen_string_literal: true

require_relative 'bug_tracker'

module Durt
  class NullBugTracker < BugTracker
    def active?
      false
    end
  end
end
