# frozen_string_literal: true

module Durt
  class ApplicationRecord < ::ActiveRecord::Base
    self.abstract_class = true

    scope :to_choice_h, -> { Hash[map { |r| [r.to_s, r] }] }

    def self.active!(record)
      update_all(active: false)
      record.reload.update(active: true)
    end

    def self.select!
      prompt.select("Select #{name}", to_choice_h).tap do |choice|
        puts "Selected: #{choice}\n"
        active!(choice)
      end
    end

    def self.prompt
      TTY::Prompt.new
    end
  end
end
