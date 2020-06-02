# frozen_string_literal: true

module Durt
  module Command
    class Init < ::Durt::Service
      def initialize
        durt_db_dir = File.expand_path('~/.durt/db')
        db_sample = File.expand_path('../../db/sample.sqlite3', __dir__)
        copy_dest = File.join(durt_db_dir, 'production.sqlite3')
        dest_exist = File.exist?(copy_dest)

        FileUtils.mkdir_p(durt_db_dir, verbose: true)
        FileUtils.cp(db_sample, copy_dest, noop: dest_exist, verbose: true)
      end
    end

    class BrowseDb < ::Durt::Service
      def initialize
        system("sqlitebrowser #{ActiveRecord::Base.connection_config[:database]}")
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
        controller = Durt::GlobalController.new

        steps << ->(_) { controller.console }
      end
    end

    class NewProject < ::Durt::Service
      def initialize
        controller = Durt::GlobalController.new

        steps << ->(_) { controller.create_project }
        steps << ->(project) { controller.create_project_config(project) }
        steps << ->(project) { controller.select_project(project) }
        steps << ->(project) { controller.switch_to_project(project) }
      end
    end

    class SelectProject < ::Durt::Service
      def initialize
        controller = Durt::GlobalController.new

        steps << ->(_) { controller.select_project }
        steps << ->(project) { controller.switch_to_project(project) }
      end
    end

    class Filter < ::Durt::Service
      def initialize
        project = Durt::Project.current_project
        controller = Durt::ProjectController.new(project)

        steps << ->(_) { controller.filter }
      end
    end

    class Memo < ::Durt::Service
      def initialize
        project = Durt::Project.current_project
        controller = Durt::ProjectController.new(project)

        steps << ->(_) { controller.sync_issues }
        steps << ->(_) { controller.select_issue }
        steps << ->(issue) { controller.enter_issue(issue) }
      end
    end

    class SelectIssue < ::Durt::Service
      def initialize
        project = Durt::Project.current_project
        controller = Durt::ProjectController.new(project)

        steps << ->(_) { controller.select_issue }
      end
    end

    class SyncIssues < ::Durt::Service
      def initialize
        project = Durt::Project.current_project
        controller = Durt::ProjectController.new(project)

        steps << ->(_) { controller.sync_issues }
      end
    end

    class NewIssue < ::Durt::Service
      def initialize
        project = Durt::Project.current_project
        controller = Durt::ProjectController.new(project)

        steps << ->(_) { controller.new_issue }
        steps << ->(issue) { controller.select_issue(issue) }
        steps << ->(issue) { controller.push_issue(issue) }
      end
    end

    class Start < ::Durt::Service
      def initialize
        project = Durt::Project.current_project
        controller = Durt::ProjectController.new(project)

        steps << ->(_) { controller.current_issue }
        steps << ->(issue) { controller.start_issue(issue) }
      end
    end

    class Stop < ::Durt::Service
      def initialize
        project = Durt::Project.current_project
        controller = Durt::ProjectController.new(project)

        steps << ->(_) { controller.current_issue }
        steps << ->(issue) { controller.stop_issue(issue) }
      end
    end

    class Stats < ::Durt::Service
      def initialize
        Durt::Project.current_project.active_issue.puts_stats
      end
    end

    class ProjectStats < ::Durt::Service
      def initialize
        Durt::Project.current_project.puts_stats
      end
    end
  end
end
