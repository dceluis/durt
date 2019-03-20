# frozen_string_literal: true

require_relative 'time_tracker'

module Durt
  class NullTimeTracker < TimeTracker
    def self.active?
      false
    end
  end
end
