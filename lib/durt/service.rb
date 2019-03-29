# frozen_string_literal: true

module Durt
  class Service
    # Based on https://github.com/Selleo/pattern/blob/master/lib/patterns/service.rb

    attr_reader :result

    def self.call(*args, **kwargs)
      new(*args, **kwargs).tap do |service|
        service.instance_variable_set('@result', service.call)
      end
    end
  end
end
