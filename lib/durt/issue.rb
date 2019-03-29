# frozen_string_literal: true

require_relative 'application_record'
require 'chronic_duration'

module Durt
  class Issue < ApplicationRecord
    before_validation :sanitize_summary
    has_many :sessions, dependent: :destroy
    belongs_to :project

    scope :active, -> { where(active: true) }

    def tracking?
      !sessions.tracking.empty?
    end

    def start_tracking!
      sessions.create(open_at: Time.now)
    end

    def stop_tracking!
      sessions.tracking.update_all(closed_at: Time.now)
    end

    def total_tracked_time
      sessions.map(&:tracked_time).sum
    end

    def estimation_ratio
      return Float::INFINITY if total_tracked_time.zero?

      estimate.to_f / total_tracked_time
    end

    def overestimated?
      estimation_ratio > 1
    end

    def underestimated?
      estimation_ratio < 1
    end

    # Presenters

    def stats
      <<~MSG

        -- #{self} --
        Estimated: #{ChronicDuration.output(estimate || 0, format: :long)}.
        Tracked: #{ChronicDuration.output(total_tracked_time, format: :long)}.
        Estimation ratio: #{estimation_ratio} (#{estimation_result_label})
        -----------------------------------

      MSG
    end

    def puts_stats
      puts stats
    end

    def estimation_result_label
      return 'Underestimated' if underestimated?
      return 'Overestimated' if overestimated?

      'Who are you?'
    end

    def label
      "[#{key}]"
    end

    def to_s
      "#{label} #{summary}"
    end

    private

    def sanitize_summary
      return unless summary

      self.summary = summary.gsub(/[^\d\w\s,]/i, '')
    end
  end
end
