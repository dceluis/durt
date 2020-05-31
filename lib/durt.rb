# frozen_string_literal: true

require 'pry'
require 'active_support'
require 'active_support/inflector'

require 'standalone_migrations'
require 'active_record'

module Durt
  def self.env
    env = ENV.fetch('DURT_ENV', 'production')

    ActiveSupport::StringInquirer.new(env)
  end
end

ENV['RAILS_ENV'] = Durt.env

StandaloneMigrations::Configurator.load_configurations

begin
  ActiveRecord::Base.establish_connection
rescue StandardError => e
  puts e.message
  puts "You might need to run 'DURT_ENV=#{Durt.env} durt init'"
end

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

