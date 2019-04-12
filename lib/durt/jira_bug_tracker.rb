# frozen_string_literal: true

require_relative 'bug_tracker'
require 'jira-ruby'

module Durt
  class JiraBugTracker < BugTracker
    attr_accessor :client

    def after_initialize
      @client = JIRA::Client.new(@config)
    end

    def fetch_issues
      fetched_issues = @client.Issue.jql(fetch_issues_query)

      fetched_issues.map do |issue|
        issues.find_or_create_by(key: issue.key) do |i|
          i.summary = issue.summary
        end
      end
    end

    def fetch_statuses
      statuses = @client.Status.all

      statuses.map do |status|
        Durt::Status
          .find_or_create_by(source_id: status.id, source: 'Jira') do |s|
          s.name = status.name
          s.active = false
        end
      end
    end

    # def estimate(key, estimation)
    #   comment(key, "Total seconds estimated for this task: #{estimation}")
    # end
    #
    # def comment(key, content)
    #   issue = client.Issue.find(key)
    #
    #   comment = issue.comments.build
    #   comment.save(body: content)
    # end
    #
    private

    def fetch_issues_query
      statuses_query = statuses.active.map { |s| "\"#{s.name}\"" }.join(', ')
      query = "assignee=currentUser() AND status in (#{statuses_query})"
      puts query
      query
    end
  end
end
