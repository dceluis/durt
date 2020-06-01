# frozen_string_literal: true

require_relative 'plugin'

module Durt
  class GithubPlugin < Plugin
    def self.demo_config
      { access_token: '<your 40 char token>', repo: 'rails/rails' }
    end

    def bug_tracker_class
      Durt::GithubBugTracker
    end

    def config_required?
      true
    end
  end
end
