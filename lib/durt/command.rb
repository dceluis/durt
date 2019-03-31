# frozen_string_literal: true

require 'active_support'

module Durt
  module Command
    class NewProject < ::Durt::Service
      def initialize
        plugin = Durt::ProjectPlugin.new('NilProject')

        steps << ->(_state) { plugin.create_project }
        steps << ->(state) { plugin.create_project_config(state) }
        steps << ->(state) { state.time_tracker_plugins.each(&:switch_project) }
      end
    end

    class SelectProject < ::Durt::Service
      def initialize
        steps << ->(_state) { Durt::Project.select! }
        steps << ->(state) { state.time_tracker_plugins.each(&:switch_project) }
      end
    end

    class Filter < ::Durt::Service
      def initialize
        Durt::Project.current_project.plugins.each do |plugin|
          steps << ->(state) { plugin.filter(state) }
        end
      end
    end

    class Memo < ::Durt::Service
      def initialize
        project_plugin = Durt::ProjectPlugin.new('NilProject')

        steps << ->(_state) { Durt::Project.current_project }
        steps << ->(project) { project_plugin.select_source(project) }

        steps << ->(bt_plugin) do
          bt_plugin.before_choose(nil)
          bt_plugin.choose(nil)
        end

        tt_plugins = current_project.time_tracker_plugins

        tt_plugins.each do |plugin|
          steps << ->(state) { plugin.before_enter(state) }
        end

        tt_plugins.each do |plugin|
          steps << ->(state) { plugin.enter(state) }
        end
      end
    end

    class Start < ::Durt::Service
      def initialize
        Durt::Project.current_project.plugins.each do |plugin|
          steps << ->(state) { plugin.start(state) }
        end
      end
    end

    class Stop < ::Durt::Service
      def initialize
        Durt::Project.current_project.plugins.each do |plugin|
          steps << ->(state) { plugin.stop(state) }
        end
      end
    end

    class Stats < ::Durt::Service
      def initialize
        steps << ->(_state) do
          Durt::Project.current_project.active_issue.puts_stats
        end
      end
    end

    class StatsAll < ::Durt::Service
      def initialize
        steps << ->(_state) do
          Durt::Project.current_project.issues.each(&:puts_stats)
        end
      end
    end
  end
end
