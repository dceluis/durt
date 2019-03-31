# frozen_string_literal: true

require_relative 'plugin'

module Durt
  class ProjectPlugin < Plugin
    def create_project
      project_name = prompt.ask('What will you name your project?')

      Durt::Project.create(name: project_name).tap do |project|
        Durt::Project.active!(project)
      end
    end

    def create_project_config(project)
      project.tap { |p| p.config!('plugins' => plugins_config) }
    end

    private

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
