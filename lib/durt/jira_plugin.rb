# frozen_string_literal: true

require_relative 'plugin'

module Durt
  class JiraPlugin < Plugin
    include Configurable

    def before_choose
      bug_tracker.fetch_issues
    end

    def filter
      message = 'Select the statuses that you want to include:'
      chosen_statuses = prompt.multi_select(message, statuses.to_choice_h)

      statuses.update_all(active: false)
      statuses.where(id: chosen_statuses).update_all(active: true)
    end

    def time_tracker
      nil
    end

    def bug_tracker
      raise NotConfiguredError unless config

      Durt::JiraBugTracker.new(config)
    end

    def config_key
      'Jira'
    end

    def statuses
      bug_tracker.statuses
    end

    private

    def prompt
      @prompt ||= TTY::Prompt.new
    end

    class NotConfiguredError < StandardError
    end
  end
end
