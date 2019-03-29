# frozen_string_literal: true

require 'active_support'

module Durt
  module Command
    class NewProject < ::Durt::Service
      def initialize
        steps << ->(_state) { Durt::Project.create_project }
      end
    end

    class SelectProject < ::Durt::Service
      def initialize
        steps << (->(_state) do
          Durt::Project.select!
          Durt::Project
            .current_project
            .time_tracker_plugins
            .each(&:switch_project)
        end)
      end
    end

    class Filter < ::Durt::Service
      def call
        Durt::Project.current_project.plugins.each(&:filter)
      end
    end

    class Memo < ::Durt::Service
      def initialize
        bt_plugin = Durt::Project.select_source(current_project)

        steps << ->(state) { bt_plugin.before_choose(state) }

        steps << ->(state) { bt_plugin.choose(state) }

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
