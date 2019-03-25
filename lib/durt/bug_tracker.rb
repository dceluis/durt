# frozen_string_literal: true

require 'jira-ruby'

module Durt
  class BugTracker

    def initialize(config = nil)
      @config = config

      after_initialize
    end

    def after_initialize; end

    def active?
      true
    end

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
      project.issues.where(source: source_name)
    end

    def statuses
      Durt::Status.where(source: source_name)
    end

    def project
      Durt::Project.current_project
    end
  end
end
