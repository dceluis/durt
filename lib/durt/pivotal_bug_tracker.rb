# frozen_string_literal: true

require_relative 'bug_tracker'
require 'tracker_api'

module Durt
  class PivotalBugTracker < BugTracker
    attr_accessor :client

    def after_initialize
      @client = TrackerApi::Client.new(token: @config[:token])
    end

    def fetch_issues
      fetch_stories
    end

    def fetch_stories
      fetched_issues = source_project.stories(filter: "owner:#{current_user.id}")

      fetched_issues.map do |issue|
        issues.find_or_create_by(key: issue.id) do |i|
          i.summary = issue.name
        end
      end
    end

    # def comment(_key, _comment)
    #   nil
    # end

    private

    def source_project
      client.project(@config[:project])
    end

    def current_user
      client.me
    end
  end
end
