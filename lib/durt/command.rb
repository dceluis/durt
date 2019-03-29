# frozen_string_literal: true

require 'active_support'

module Durt
  module Command
    class NewProject < ::Durt::Service
      def call
        Durt::Project.create_project
      end
    end

    class SelectProject < ::Durt::Service
      def call
        Durt::Project.select!
        Durt::Project
          .current_project
          .time_tracker_plugins
          .each(&:switch_project)
      end
    end

    class Filter < ::Durt::Service
      def call
        Durt::Project.current_project.plugins.each(&:filter)
      end
    end

    class Memo < ::Durt::Service
      def initialize
        @state = nil

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

      def call
        steps.each do |step|
          @state = step.call(@state)
        end
        @state
      end

      private

      def steps
        @steps ||= []
      end

      def push_step(step)
        steps << step
      end
    end

    class Start < ::Durt::Service
      def call
        Durt::Project.current_project.plugins.each(&:start)
      end
    end

    class Stop < ::Durt::Service
      def call
        Durt::Project.current_project.plugins.each(&:stop)
      end
    end

    class Stats < ::Durt::Service
      def call
        Durt::Project.current_project.active_issue.puts_stats
      end
    end

    class StatsAll < ::Durt::Service
      def call
        Durt::Project.current_project.issues.each(&:puts_stats)
      end
    end
  end
end
