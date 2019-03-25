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
      issues = project.stories(filter: "owner:#{current_user.id}")

      issues.map do |issue|
        Durt::Issue.find_or_create_by(key: issue.id, source: 'Pivotal') do |i|
          i.summary = issue.name
        end
      end
    end

    def comment(_key, _c)
      nil
    end

    private

    def project
      client.project(@config[:project])
    end

    def current_user
      client.me
    end
  end
end
