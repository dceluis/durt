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

    def self.select_source(project)
      bug_tracker_plugins = project.bug_tracker_plugins

      return bug_tracker_plugins.first if bug_tracker_plugins.length == 1

      source_choices =
        bug_tracker_plugins.map { |btp| [btp.plugin_name, btp] }.to_h

      prompt.select('Select source', source_choices)
    end
  end
end
