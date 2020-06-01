# frozen_string_literal: true

require_relative 'bug_tracker'
require 'octokit'

module Durt
  class GithubBugTracker < BugTracker
    attr_accessor :client

    def after_initialize
      @client = Octokit::Client.new(@config)
      @client.auto_paginate = true
    end

    def fetch_issues
      fetched_issues = client.issues(fetch_issues_query)

      fetched_issues.map do |issue|
        {
          key: issue.number,
          summary: issue.title,
          source: source_name,
          project: project
        }
      end
    end

    # def comment(_key, _content)
    #   nil
    # end

    private

    def fetch_issues_query
      query = @config[:repo]
      puts query
      query
    end
  end
end
