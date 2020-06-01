# frozen_string_literal: true

require_relative 'plugin'

module Durt
  class GithubPlugin < Plugin
    def self.demo_config
      { login: 'username', password: 'password!', repo: 'rails/rails' }
    end

    def bug_tracker_class
      Durt::GithubBugTracker
    end

    def config_required?
      true
    end
  end
end
