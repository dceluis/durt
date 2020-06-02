module Durt
  class GlobalController
    def create_project
      project_name = prompt.ask('What will you name your project?')

      Durt::Project.create(name: project_name)
    end

    def create_project_config(project)
      project.tap { |p| p.config!('plugins' => plugins_config) }
    end

    def select_project(project = nil)
      projects = Durt::Project.all

      project ||=
        begin
          prompt.select('Select project:', projects.to_choice_h)
        end

      projects.update_all(active: false)
      project.tap(&:active!)
    end

    def switch_to_project(project)
      project.tap do |p|
        p.time_tracker_plugins.each(&:switch_project)
      end
    end

    def console
      binding.pry
    end

    private

    def plugins_config
      all_plugins = Durt::Plugin.all
      plugin_choices =
        (all_plugins - [Durt::LocalPlugin])
        .map { |p| [p.plugin_name, p] }
        .to_h

      prompt
        .multi_select('Select plugins', plugin_choices)
        .push(Durt::LocalPlugin)
        .map { |p| [p.plugin_name, p.demo_config] }
        .to_h
    end

    def prompt
      @prompt ||= TTY::Prompt.new
    end
  end
end
