# frozen_string_literal: true

require 'active_record'
require_relative 'db_config'

ActiveRecord::Base.establish_connection(Durt::DB_CONFIG)

module Durt
  class ApplicationRecord < ::ActiveRecord::Base
    self.abstract_class = true

    scope :to_choice_h, -> { Hash[map { |r| [r.to_s, r] }] }

    def active!
      reload.update(active: true)
    end

    def self.select!
      prompt.select("Select #{self.class.name}", all.to_choice_h).tap do |choice|
        puts "Selected: #{choice}\n"
        update_all(active: false)
        choice.active!
      end
    end

    def self.prompt
      TTY::Prompt.new
    end
  end
end
