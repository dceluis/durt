# frozen_string_literal: true

require 'active_record'

db_config_file_path = File.expand_path('../../db/config.yml', __dir__)
db_config = YAML.load(File.read(db_config_file_path))['production']
db_config[:database] = File.expand_path('../../' + db_config['database'], __dir__)

ActiveRecord::Base.establish_connection(db_config)

module Durt
  class ApplicationRecord < ::ActiveRecord::Base
    self.abstract_class = true
  end
end
