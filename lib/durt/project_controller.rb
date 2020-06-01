# frozen_string_literal: true

require 'securerandom'
require_relative 'plugin'

module Durt
  class ProjectController
    def current_project
      Durt::Project.current_project
    end

    def current_issue
      current_project.active_issue
    end

    def console
      binding.pry
    end

    def create_project
      project_name = prompt.ask('What will you name your project?')

      Durt::Project.create(name: project_name).tap(&:active!)
    end

    def select_project
      select_from_relation(Durt::Project.all)
    end

    def select_from_relation(relation)
      prompt.select("Select: ", relation.to_choice_h).tap(&:active!)
    end

    def switch_to_project(project)
      project.tap do |p|
        p.time_tracker_plugins.each(&:switch_project)
      end
    end

    def create_project_config(project)
      project.tap { |p| p.config!('plugins' => plugins_config) }
    end

    def filter(project)
      project.tap do |p|
        p.plugins.each do |plugin|
          plugin.filter(nil)
        end
      end
    end

    def start_issue(issue)
      issue.tap do |i|
        plugins = i.project.time_tracker_plugins

        plugins.each do |plugin|
          plugin.start(i)
        end
      end

      return if issue.tracking?

      issue.start_tracking!
    end

    def stop_issue(issue)
      issue.tap do |i|
        plugins = i.project.time_tracker_plugins

        plugins.each do |plugin|
          plugin.stop(i)
        end
      end

      return unless issue.tracking?

      issue.stop_tracking!
    end

    def choose_issue(project)
      project.tap do |p|
        plugin = select_source(p)

        plugin.before_choose(nil)

        select_from_relation(plugin.issues)
      end
    end

    def process_issue(project)
      project.tap do |p|
        plugins = p.plugins

        plugins.each do |plugin|
          plugin.before_enter(p.active_issue)
        end

        plugins.each do |plugin|
          plugin.enter(p.active_issue)
        end
      end
    end

    def new_issue(project)
      plugin = select_source(project)

      issue_name = prompt.ask('Enter issue name:')

      issue_data = {
        # Key should probably be ref_id and not be required
        key: SecureRandom.uuid,
        summary: issue_name,
        project: project,
        source: plugin.source_name
      }

      issue_data = plugin.process_new_issue(issue_data)

      Durt::Issue.create(issue_data).active!
    end

    def print_stats(model)
      model.tap(&:puts_stats)
    end

    private

    def bug_tracker_choices_for(project)
      choice_plugins =
        project.bug_tracker_plugins + [LocalPlugin.new(project)]

      choice_plugins.map { |p| [p.plugin_name, p] }.to_h
    end

    def select_source(project)
      choices = bug_tracker_choices_for(project)

      return choices.values.first if choices.count == 1

      prompt.select('Select source', choices)
    end

    def plugins_config
      plugin_choices = Durt::Plugin.all.map(&:plugin_name)

      prompt
        .multi_select('Select plugins', plugin_choices)
        .map do |p_name|
          [p_name, Durt::Plugin.find_by_plugin_name(p_name).demo_config]
        end
        .to_h
    end

    def prompt
      @prompt ||= TTY::Prompt.new
    end
  end
end
