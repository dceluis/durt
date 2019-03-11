# frozen_string_literal: true

require 'durt/application_record'

module Durt
  class Status < ApplicationRecord
    scope :active, -> { where(active: true) }

    def self.config?
      !active.empty?
    end
  end
end
