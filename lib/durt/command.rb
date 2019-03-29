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
      def call
        bt_plugin = Durt::Project.select_source(current_project)

        bt_plugin.before_choose
        issue = bt_plugin.choose

        tt_plugins = current_project.time_tracker_plugins

        tt_plugins.each { |plugin| plugin.before_enter(issue) }
        tt_plugins.each { |plugin| plugin.enter(issue) }
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
