# frozen_string_literal: true

require_relative 'plugin'

module Durt
  class GithubPlugin < Plugin
    def self.demo_config
      { login: 'username', password: 'password!', repo: 'rails/rails' }
    end

    def before_choose
      bug_tracker.fetch_issues
    end

    def bug_tracker
      raise NotConfiguredError unless config

      Durt::GithubBugTracker.new(config)
    end

    class NotConfiguredError < StandardError
    end
  end
end
