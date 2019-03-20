# frozen_string_literal: true

require_relative 'application_record'

module Durt
  class Status < ApplicationRecord
    scope :active, -> { where(active: true) }

    scope :to_choice_h, -> { Hash[map { |s| [s.name, s.id] }] }
  end
end
