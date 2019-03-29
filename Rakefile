# frozen_string_literal: true

begin
  require 'rspec/core/rake_task'
  require 'cucumber'
  require 'cucumber/rake/task'
  require 'standalone_migrations'

  RSpec::Core::RakeTask.new(:spec)

  Cucumber::Rake::Task.new(:features) do |t|
    t.cucumber_opts = 'features --format pretty'
  end

  task default: %i[spec features]

  StandaloneMigrations::Tasks.load_tasks
rescue LoadError
  puts 'no rspec or cucumber available'
end
