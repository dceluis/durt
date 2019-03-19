# frozen_string_literal: true

module Durt
  class Project
    def self.current_project
      new
    end

    def plugins
      Durt::Plugin.all
    end

    # def bug_trackers
    #   plugins.find_all { |plugin| !plugin.bug_tracker.nil? }
    # end
    #
    # def time_trackers
    #   plugins.find_all { |plugin| !plugin.time_tracker.nil? }
    # end
  end
end

