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
      issues = client.issues(fetch_issues_query)

      issues.map do |issue|
        Durt::Issue.find_or_create_by(key: issue.number, source: 'Github') do |i|
          i.summary = issue.title
        end
      end
    end

    def comment(_key, _content)
      nil
    end

    private

    def fetch_issues_query
      query = @config[:repo]
      puts query
      query
    end
  end
end
