# frozen_string_literal: true

require_relative 'application_record'

module Durt
  class Project < ApplicationRecord
    include Configurable

    has_many :issues, dependent: :destroy

    def self.current_project
      @current_project ||= find_by!(active: true)
    end

    def to_s
      name
    end

    def plugins
      @plugins ||=
        config['plugins'].map do |plugin_name, plugin_config|
          Durt::Plugin.find_by_plugin_name(plugin_name).new(self, plugin_config)
        end
    end

    def bug_tracker_plugins
      plugins.find_all { |p| p.bug_tracker.active? }
    end

    def time_tracker_plugins
      plugins.find_all { |p| p.time_tracker.active? }
    end

    def config_key
      name
    end

    def active_issue
      issues.find_by!(active: true)
    end
  end
end
