# frozen_string_literal: true

require_relative 'plugin'

module Durt
  class PivotalPlugin < Plugin
    def self.demo_config
      { token: 'account_token', project: 'project' }
    end

    def before_choose
      bug_tracker.fetch_issues
    end

    def bug_tracker_class
      Durt::PivotalBugTracker
    end

    def config_required?
      true
    end
  end
end
