# frozen_string_literal: true

require 'jira-ruby'

module Durt
  class BugTracker
    attr_reader :project

    def initialize(project, config = nil)
      @project = project
      @config = config

      after_initialize
    end

    def after_initialize; end

    def active?
      true
    end

    def choose(values)
      ids = values.map(&:id)

      issues.where(id: ids).select!
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
  end
end
