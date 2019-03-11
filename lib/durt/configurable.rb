# frozen_string_literal: true

require 'yaml/store'

module Durt
  module Configurable
    STORE_FILE_NAME = '.durt.yml'
    STORE_FILE_PATH = File.expand_path("~/#{STORE_FILE_NAME}")

    def self.extended(base)
      base.config_store.transaction do
        store = base.config_store
        top_level_config = store[base.config_key]

        store[base.config_key] = { base_config: nil } if top_level_config.nil?
      end
    end

    def config(key: nil)
      config_store.transaction do
        if key.nil?
          config_store[config_key][:base_config]
        else
          config_store[config_key][key]
        end
      end
    end

    def config!(obj, key: nil)
      config_store.transaction do
        if key.nil?
          serialized = config_serializer.call(obj)

          config_store[config_key][:base_config] = serialized
        else
          config_store[config_key][key] = obj
        end
      end
    end

    def config?
      !config.nil?
    end

    def config_serializer
      ->(obj) { obj }
    end

    def config_key
      name
    end

    def config_store
      @config_store ||= YAML::Store.new(STORE_FILE_PATH)
    end
  end
end
