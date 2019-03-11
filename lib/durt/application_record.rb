# frozen_string_literal: true

require 'active_record'
require_relative 'db_config'

ActiveRecord::Base.establish_connection(Durt::DB_CONFIG)

module Durt
  class ApplicationRecord < ::ActiveRecord::Base
    self.abstract_class = true
  end
end
