# frozen_string_literal: true

require_relative 'plugin'

module Durt
  class ProjectController
    def current_project
      Durt::Project.current_project
    end

    def current_issue
      current_project.active_issue
    end

    def create_project
      project_name = prompt.ask('What will you name your project?')

      Durt::Project.create(name: project_name).tap do |project|
        Durt::Project.active!(project)
      end
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
    end

    def stop_issue(issue)
      issue.tap do |i|
        plugins = i.project.time_tracker_plugins

        plugins.each do |plugin|
          plugin.stop(i)
        end
      end
    end

    def choose_issue(project)
      project.tap do |p|
        plugin = select_source(p)

        plugin.before_choose(nil)
        plugin.choose(nil)
      end
    end

    def process_issue(project)
      project.tap do |p|
        plugins = p.time_tracker_plugins

        plugins.each do |plugin|
          plugin.before_enter(p.active_issue)
        end

        plugins.each do |plugin|
          plugin.enter(p.active_issue)
        end
      end
    end

    def print_stats(model)
      model.tap(&:puts_stats)
    end

    private

    def select_source(project)
      bug_tracker_plugins = project.bug_tracker_plugins

      return bug_tracker_plugins.first if bug_tracker_plugins.length == 1

      source_choices =
        bug_tracker_plugins.map { |btp| [btp.plugin_name, btp] }.to_h

      prompt.select('Select source', source_choices)
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
