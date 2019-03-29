# frozen_string_literal: true

require_relative 'plugin'

module Durt
  class JiraPlugin < Plugin
    def self.demo_config
      {
        username: 'example@mail.com',
        password: 'password',
        site: 'http://project.atlassian.net:443/',
        context_path: '',
        auth_type: :basic
      }
    end

    def before_choose(_value)
      bug_tracker.fetch_issues
    end

    def filter
      bug_tracker.fetch_statuses

      message = 'Select the statuses that you want to include:'
      chosen_statuses = prompt.multi_select(message, statuses.to_choice_h)

      statuses.update_all(active: false)
      statuses.where(id: chosen_statuses).update_all(active: true)
    end

    def bug_tracker_class
      Durt::JiraBugTracker
    end

    def statuses
      bug_tracker.statuses
    end

    def prompt
      TTY::Prompt.new
    end
  end
end
