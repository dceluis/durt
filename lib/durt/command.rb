# frozen_string_literal: true

module Durt
  module Command
    class BrowseDb < ::Durt::Service
      def initialize
        system("sqlitebrowser #{Durt::DB_PATH}")
      end
    end

    class Version < ::Durt::Service
      def initialize
        puts Durt::VERSION
      end
    end

    class NullCommand < ::Durt::Service
      def initialize
        puts 'Unknown command'
        exit
      end
    end

    class Console < ::Durt::Service
      def initialize
        controller = Durt::ProjectController.new

        steps << ->(_state) { controller.console }
      end
    end

    class NewProject < ::Durt::Service
      def initialize
        controller = Durt::ProjectController.new

        steps << ->(_state) { controller.create_project }
        steps << ->(state) { controller.create_project_config(state) }
        steps << ->(project) { controller.switch_to_project(project) }
      end
    end

    class SelectProject < ::Durt::Service
      def initialize
        controller = Durt::ProjectController.new

        steps << ->(_state) { controller.select_project }
        steps << ->(project) { controller.switch_to_project(project) }
      end
    end

    class Filter < ::Durt::Service
      def initialize
        controller = Durt::ProjectController.new

        steps << ->(_state) { controller.current_project }
        steps << ->(project) { controller.filter(project) }
      end
    end

    class Memo < ::Durt::Service
      def initialize
        controller = Durt::ProjectController.new

        steps << ->(_state) { controller.current_project }
        steps << ->(project) { controller.choose_issue(project) }
        steps << ->(project) { controller.process_issue(project) }
      end
    end

    class Start < ::Durt::Service
      def initialize
        controller = Durt::ProjectController.new

        steps << ->(_state) { controller.current_issue }
        steps << ->(issue) { controller.start_issue(issue) }
      end
    end

    class Stop < ::Durt::Service
      def initialize
        controller = Durt::ProjectController.new

        steps << ->(_state) { controller.current_issue }
        steps << ->(issue) { controller.stop_issue(issue) }
      end
    end

    class Stats < ::Durt::Service
      def initialize
        controller = Durt::ProjectController.new

        steps << ->(_state) { controller.current_issue }
        steps << ->(issue) { controller.print_stats(issue) }
      end
    end

    class StatsAll < ::Durt::Service
      def initialize
        controller = Durt::ProjectController.new

        steps << ->(_state) { controller.current_project }
        steps << ->(project) { controller.print_stats(project) }
      end
    end
  end
end
