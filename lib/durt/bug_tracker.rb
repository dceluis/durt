# frozen_string_literal: true

require 'jira-ruby'

module Durt
  class BugTracker
    def fetch_issues
      raise NotImplementedError
    end

    def fetch_statuses
      raise NotImplementedError
    end

    def source_name
      self.class.name.split('::').last.sub('BugTracker', '')
    end

    def issues
      Durt::Issue.where(source: source_name)
    end

    def statuses
      Durt::Status.where(source: source_name)
    end
  end
end
