# frozen_string_literal: true

require 'active_support'

module Durt
  module Command
    class NewProject < ::Durt::Service
      def initialize
        plugin = Durt::ProjectController.new

        steps << ->(_state) { plugin.create_project }
        steps << ->(state) { plugin.create_project_config(state) }
        steps << ->(project) { plugin.switch_to_project(project) }
      end
    end

    class SelectProject < ::Durt::Service
      def initialize
        plugin = Durt::ProjectController.new

        steps << ->(_state) { Durt::Project.select! }
        steps << ->(project) { plugin.switch_to_project(project) }
      end
    end

    class Filter < ::Durt::Service
      def initialize
        plugin = Durt::ProjectController.new

        steps << ->(_state) { plugin.current_project }
        steps << ->(project) { plugin.filter(project) }
      end
    end

    class Memo < ::Durt::Service
      def initialize
        plugin = Durt::ProjectController.new

        steps << ->(_state) { plugin.current_project }
        steps << ->(project) { plugin.choose_issue(project) }
        steps << ->(project) { plugin.process_issue(project) }
      end
    end

    class Start < ::Durt::Service
      def initialize
        plugin = Durt::ProjectController.new

        steps << ->(_state) { plugin.current_issue }
        steps << ->(issue) { plugin.start_issue(issue) }
      end
    end

    class Stop < ::Durt::Service
      def initialize
        plugin = Durt::ProjectController.new

        steps << ->(_state) { plugin.current_issue }
        steps << ->(issue) { plugin.stop_issue(issue) }
      end
    end

    class Stats < ::Durt::Service
      def initialize
        plugin = Durt::ProjectController.new

        steps << ->(_state) { plugin.current_issue }
        steps << ->(issue) { plugins.print_stats(issue) }
      end
    end

    class StatsAll < ::Durt::Service
      def initialize
        plugin = Durt::ProjectController.new

        steps << ->(_state) { plugin.current_project }
        steps << ->(project) { plugins.print_stats(project) }
      end
    end
  end
end
