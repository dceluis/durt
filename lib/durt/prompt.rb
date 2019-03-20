# frozen_string_literal: true

require 'tty-prompt'

module Durt
  class Prompt
    def initialize
      @prompt = TTY::Prompt.new
    end

    def pick_issue
      @prompt.select('What will you work on?', build_issue_choices)
    end

    def edit_estimate(issue)
      puts "Selected: #{issue}\n"
      estimate_input =
        @prompt.ask('How long do you think this task will take you?')

      input_in_seconds = estimate_input_to_seconds(estimate_input)

      Durt::Services::Estimate.call(issue: issue, estimation: input_in_seconds)
      issue
    end

    def build_issue_choices
      issues = Durt::Issue.all
      choices = {}

      issues.map do |issue|
        choices[issue.to_s] = issue
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
  end
end
