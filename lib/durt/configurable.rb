# frozen_string_literal: true

require 'yaml/store'

module Durt
  module Configurable
    STORE_FILE_NAME = '.durt.yml'
    STORE_FILE_PATH = File.expand_path("~/#{STORE_FILE_NAME}")

    def config
      config_store.transaction do
        config_store[config_key]
      end
    end

    def config!(value)
      config_store.transaction do
        config_store[config_key] = value
      end
    end

    def config?
      !config.nil?
    end

    def config_key
      raise NotImplementedError
    end

    def config_store
      @config_store ||= YAML::Store.new(STORE_FILE_PATH)
    end
  end
end
