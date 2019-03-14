# frozen_string_literal: true

require 'tty-prompt'

module Durt
  class Prompt
    def initialize
      @prompt = TTY::Prompt.new
    end

    def select_issue
      issues = bug_tracker.fetch_issues

      @prompt.select('What will you work on?', build_issue_choices(issues))
    end

    def edit_estimate(issue)
      puts "Selected: #{issue}\n"
      estimate_input =
        @prompt.ask('How long do you think this task will take you?')

      issue.update(estimate: estimate_input_to_seconds(estimate_input))
      issue
    end

    def select_statuses
      statuses = bug_tracker.fetch_statuses

      @prompt
        .multi_select('Select the statuses that you want to include:',
                      build_status_choices(statuses))
    end

    def build_issue_choices(issues)
      choices = {}
      issues.map do |issue|
        choices[issue.to_s] = issue
      end
      choices
    end

    def build_status_choices(statuses)
      choices = {}
      statuses.map do |status|
        choices[status.name] = status.id
      end
      choices
    end

    def estimate_input_to_seconds(input)
      digit = input.gsub(/[^\d\.]/, '').to_f
      measure_char = input.gsub(/[\d\.]/, '').strip.chr

      time_in_seconds = if measure_char == 's'
                          digit
                        elsif measure_char == 'm'
                          digit * 60
                        elsif measure_char == 'h'
                          digit * 3600
                        else
                          raise WhatKindOfTimeIsThatError
                        end

      time_in_seconds.ceil(2)
    end

    def bug_tracker
      @bug_tracker ||= Durt::JiraBugTracker.new
    end
  end
end
