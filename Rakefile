# frozen_string_literal: true

ENV['RAILS_ENV'] = ENV.fetch('DURT_ENV', 'production')

begin
  require 'rspec/core/rake_task'
  require 'standalone_migrations'

  RSpec::Core::RakeTask.new(:spec)

  task default: %i[spec]

  StandaloneMigrations::Tasks.load_tasks
rescue LoadError
  puts 'no rspec available'
end
