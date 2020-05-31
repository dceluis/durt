# frozen_string_literal: true

require 'pry'
require 'active_support'
require 'active_support/inflector'
require 'erb'

ENV['RAILS_ENV'] = ENV.fetch('DURT_ENV', 'production')

require 'active_record'

module Durt
  def self.env
    ActiveSupport::StringInquirer.new(ENV['RAILS_ENV'])
  end
end

config_file_path = File.expand_path('../db/config.yml', __dir__)

db_config =
  YAML.load(ERB.new(IO.read(config_file_path)).result)

raise 'Sample db should be blank and remain unused' if Durt.env.sample?

ActiveRecord::Base.establish_connection(db_config[Durt.env])

require_relative 'durt/version'
require_relative 'durt/configurable'
require_relative 'durt/project'
require_relative 'durt/service'
require_relative 'durt/command'

require_relative 'durt/project_controller'
require_relative 'durt/internal_plugin'
require_relative 'durt/upwork_plugin'
require_relative 'durt/github_plugin'
require_relative 'durt/jira_plugin'
require_relative 'durt/pivotal_plugin'
require_relative 'durt/ebs_plugin'

require_relative 'durt/issue'
require_relative 'durt/session'
require_relative 'durt/status'

require_relative 'durt/null_time_tracker'
require_relative 'durt/internal_tracker'
require_relative 'durt/upwork_tracker'
require_relative 'durt/null_bug_tracker'
require_relative 'durt/github_bug_tracker'
require_relative 'durt/jira_bug_tracker'
require_relative 'durt/pivotal_bug_tracker'
require_relative 'durt/internal_bug_tracker'

