# frozen_string_literal: true

require 'active_support'
require 'active_support/inflector'

module Durt
  def self.env
    env = ENV.fetch('DURT_ENV', 'runtime')

    ActiveSupport::StringInquirer.new(env)
  end
end

require 'pry' if Durt.env.development?

require_relative 'durt/version'
require_relative 'durt/configurable'
require_relative 'durt/db_config'
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

