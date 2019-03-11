# encoding: utf-8
require File.expand_path('lib/durt/version', __dir__)

Gem::Specification.new do |s|
  s.name = 'durt'
  s.version = Durt::VERSION
  s.authors = ['Luis Felipe Sanchez']
  s.homepage = 'https://durt.github.io'
  s.summary = %q{Unify tools for EBS}
  s.description = %q{EBS tool for me}
  s.licenses = ['MIT']

  s.files = %x(git ls-files -z).split("\x0").reject { |f| f.match(%r{^(coverage|test|spec|features)/}) }
  s.test_files = %x(git ls-files -z).split("\x0").select { |f| f.match(%r{^(test|spec|features)/}) }
  s.executables = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.require_paths = ['lib']

  # Dependencies list:
  s.add_runtime_dependency 'activerecord', '~> 5.2'
  s.add_runtime_dependency 'chronic_duration', '~> 0.10'
  s.add_runtime_dependency 'jira-ruby', '~> 1.6'
  s.add_runtime_dependency 'sqlite3', '~> 1.3.6'
  s.add_runtime_dependency 'tty-prompt', '~> 0.18'

  s.add_development_dependency 'aruba', '~> 0.14'
  s.add_development_dependency 'cucumber', '~> 1.3'
  s.add_development_dependency 'pry', '~> 0.11'
  s.add_development_dependency 'rake', '~> 12.3'
  s.add_development_dependency 'rspec', '~> 3.7'
  s.add_development_dependency 'simplecov', '~> 0.15'
  s.add_development_dependency 'standalone_migrations', '~> 5.2'
end
