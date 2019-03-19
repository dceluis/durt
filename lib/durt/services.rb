# frozen_string_literal: true

module Durt
  module Services
    class Base
      # Based on https://github.com/Selleo/pattern/blob/master/lib/patterns/service.rb

      attr_reader :result

      def self.call(*args, **kwargs)
        new(*args, **kwargs).tap do |service|
          service.instance_variable_set(
            '@result',
            service.call
          )
        end
      end
    end

    class Estimate < Base
      def initialize(issue:, estimation:)
        @issue = issue
        @estimation = estimation
      end

      def call
        @issue.update(estimate: @estimation)

        tracker.estimate(@issue.key, @estimation)
      end

      private

      def tracker
        project[:tracker]
      end

      def project
        { tracker: JiraBugTracker.new }
      end
    end
  end
end
