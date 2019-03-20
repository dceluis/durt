# frozen_string_literal: true

require 'tty-prompt'

module Durt
  class Prompt
    def initialize
      @prompt = TTY::Prompt.new
    end

    def pick_issue
      @prompt.select('What will you work on?', build_issue_choices).tap do |i|
        puts "Selected: #{i}\n"
      end
    end

    def build_issue_choices
      issues = Durt::Issue.all
      choices = {}

      issues.map do |issue|
        choices[issue.to_s] = issue
      end
      choices
    end
  end
end
