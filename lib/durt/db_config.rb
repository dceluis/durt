# frozen_string_literal: true

module Durt
  db_config_path = File.expand_path('../../db/config.yml', __dir__)
  db_config = YAML.load(File.read(db_config_path))['production']

  DB_PATH = File.expand_path('../../' + db_config['database'], __dir__)

  db_config[:database] = DB_PATH

  DB_CONFIG = db_config.freeze
end
