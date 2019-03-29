# frozen_string_literal: true

require 'active_support'

module Durt
  module Command
    class NewProject < ::Durt::Service
      def call
        Durt::Project.create_project
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

    class Stats
      def call
        Durt::Project.current_project.active_issue.puts_stats
      end
    end
  end
end
