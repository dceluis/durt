# frozen_string_literal: true

require_relative 'application_record'

module Durt
  class Project < ApplicationRecord
    include Configurable

    def self.current_project
      @current_project ||= find_by!(active: true)
    end

    def plugins
      @plugins ||=
        config['plugins'].map do |plugin_name, plugin_config|
          Durt::Plugin.find_by_plugin_name(plugin_name).new(plugin_config)
        end
    end

    def bug_tracker_plugins
      plugins.find_all { |p| p.bug_tracker.active? }
    end

    def time_tracker_plugins
      plugins.find_all { |p| p.time_tracker.active? }
    end

    def issues
      bug_tracker_plugins.map(&:issues).flatten
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

    def self.create_project
      project_name = prompt.ask('What will you name our project?')

      update_all(active: false)
      create(name: project_name, active: true).tap do |project|
        create_project_config(project)
      end
    end

    def self.create_project_config(project)
      plugin_choices = Durt::Plugin.all.map(&:plugin_name)

      plugins_config =
        prompt
        .multi_select('Select plugins', plugin_choices)
        .map { |p_name| [p_name, Durt::Plugin.find_by_plugin_name(p_name).demo_config] }
        .to_h

      project.config!('plugins' => plugins_config)
    end

    def self.prompt
      TTY::Prompt.new
    end
  end
end
