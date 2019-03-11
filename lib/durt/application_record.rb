# frozen_string_literal: true

require 'active_record'

db_config_file_path = File.expand_path('../../db/config.yml', __dir__)
db_config = YAML.load(File.read(db_config_file_path))

ActiveRecord::Base.establish_connection(db_config['development'])

module Durt
  class ApplicationRecord < ::ActiveRecord::Base
    self.abstract_class = true
  end
end
