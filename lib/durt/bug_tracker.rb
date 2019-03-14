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

    def self.source_name
      name.split('::').last.sub('BugTracker', '')
    end

    def source_name
      self.class.source_name
    end

    def issues
      Durt::Issue.where(source: source_name)
    end

    def statuses
      Durt::Status.where(source: source_name)
    end

    class NotConfiguredError < StandardError
    end
  end
end
