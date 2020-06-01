# frozen_string_literal: true

require_relative 'plugin'

module Durt
  class EbsPlugin < Plugin
    def before_enter(issue)
      return if issue.estimate?

      edit_estimate(issue)
    end

    def edit_estimate(issue)
      puts issue.to_s
      estimate_input =
        prompt.ask('How long do you think this task will take you?')

      input_in_seconds = estimate_input_to_seconds(estimate_input)

      issue.update(estimate: input_in_seconds)
      issue
    end

    private

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

    def prompt
      @prompt ||= TTY::Prompt.new
    end
  end
end

module Durt
  module Command
    class EditEstimate < Durt::Service
      def initialize
        controller = Durt::ProjectController.new

        steps << ->(_state) { controller.current_issue }
        steps << ->(issue) { controller.edit_estimate(issue) }
      end
    end
  end
end

module Durt
  class ProjectController
    def edit_estimate(issue)
      EbsPlugin.new(issue.project).edit_estimate(issue)
    end
  end
end
