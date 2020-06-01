# frozen_string_literal: true

module Durt
  class Service
    # Based on https://github.com/Selleo/pattern/blob/master/lib/patterns/service.rb

    attr_reader :result
    attr_reader :state

    def self.call(*args)
      new(*args).tap do |service|
        service.instance_variable_set('@result', service.call)
      end
    end

    def call
      steps.each do |step|
        @state = step.call(@state)
      end

      self
    end

    private

    def steps
      @steps ||= []
    end
  end
end
