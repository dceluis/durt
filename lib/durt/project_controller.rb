# frozen_string_literal: true

require 'securerandom'
require_relative 'plugin'

module Durt
  class ProjectController
    attr_reader :project

    def initialize(project)
      @project = project
    end

    def current_issue
      project.active_issue
    end

    def select_issue(issue = nil)
      issue ||=
        begin
          plugin = select_source(project)

          raise "No plugin selected" unless plugin.present?

          issues = plugin.issues

          raise "No issue available to select" unless issues.present?

          prompt.select("Select issue: ", issues.to_choice_h)
        end

      project.issues.update_all(active: false)
      issue.tap(&:active!)
    end

    def filter
      project.tap do |p|
        p.plugins.each do |plugin|
          plugin.filter(nil)
        end
      end
    end

    def start_issue(issue)
      issue.tap do |i|
        plugins = project.time_tracker_plugins

        plugins.each do |plugin|
          plugin.start(i)
        end
      end

      issue.start_tracking!
    end

    def stop_issue(issue)
      issue.tap do |i|
        plugins = project.time_tracker_plugins

        plugins.each do |plugin|
          plugin.stop(i)
        end
      end

      issue.stop_tracking!
    end

    def enter_issue(issue)
      project.tap do |p|
        plugins = p.plugins

        plugins.each do |plugin|
          plugin.before_enter(issue)
        end

        plugins.each do |plugin|
          plugin.enter(issue)
        end
      end
    end

    def new_issue
      plugin = select_source(project)

      issue_name = prompt.ask('Enter issue name:')

      issue_data = {
        # Key should probably be ref_id and not be required
        key: SecureRandom.uuid,
        summary: issue_name,
        project: project,
        source: plugin.source_name
      }

      Durt::Issue.create(issue_data)
    end

    def push_issue(issue)
      plugin = issue.plugin

      ref_id = plugin.push_issue(issue)

      issue.update(key: ref_id)
    end

    def sync_issues
      project.tap do |p|
        plugin = select_source(p, include_local: false)

        fetched = plugin.fetch_issues

        fetched.map do |attrs|
          Durt::Issue.find_or_create_by(key: attrs[:key]) do |issue|
            issue.attributes = attrs
          end
        end
      end
    end

    private

    def bug_tracker_choices_for(project, include_local = true)
      choice_plugins = project.bug_tracker_plugins
      choice_plugins = choice_plugins.reject { |p| p.plugin_name == 'Local' } unless include_local

      choice_plugins.map { |p| [p.plugin_name, p] }.to_h
    end

    def select_source(project, include_local: true)
      choices = bug_tracker_choices_for(project, include_local)

      return choices.values.first if choices.count == 1

      prompt.select('Select source', choices)
    end

    def prompt
      @prompt ||= TTY::Prompt.new
    end
  end
end
