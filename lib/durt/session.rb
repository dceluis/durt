# frozen_string_literal: true

require 'durt/application_record'

module Durt
  class Session < ApplicationRecord
    belongs_to :issue

    scope :tracking, -> { where(closed_at: nil) }

    def tracked_time
      (closed_at || Time.now) - open_at
    end
  end
end
