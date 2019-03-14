# Durt

Small Ruby program generated using https://github.com/snada/generator-ruby-cmd

## Install

This is a Ruby program and uses Bundler to ensure dependencies consistency. On your machine navigate to the project root and run:

```bash
# If not already installed:
gem install bundler

bundle install
```

This code is packaged as a Ruby gem, and it should be built and installed running these commands:

```bash
gem build durt.gemspec
gem install durt
```

## Setup

Make sure Upwork client (or pick time tracker) is running and in the correct
project.

Then, create `.durt.yml` at your root folder. Example for Jira project:

```
# ~/.durt.yml

---
Jira:
  :username: username@example.com
  :password: yourpassword
  :site: http://yourproject.atlassian.net:443/
  :context_path: ''
  :auth_type: :basic
```

## Usage

If you followed the above instruction and the gem is installed on the system, you should have the binary file ready to run from your command line.

Start by choosing the issue statuses that you'll be able to choose from:

```bash
durt statuses
```

Next, pick an issue to work on:

```bash
durt memo
```

You will be asked to estimate the time it will take you to work on this issue.
Valid inputs include: `29 minutes`, `3 hours`, `123249 sec` `3 min`, etc.
As long as it includes a number and something that resembles a time measure it
will not complain.

If you wish to execute without installing, you can by launching this command from the project root directory:

```bash
ruby -Ilib bin/durt memo
```

Other commands include:

```bash
durt start
durt stop
durt stats
durt stats-all
durt edit-estimate
```

## Testing

This code is covered with both unit tests and feature tests, using Rspec (testing library classes) and Cucumber/Aruba (testing the actual command line program).

You can launch the test suite by running:

```bash
bundle exec rake spec
bundle exec rake features
#launch both:
bundle exec rake
```

For unit tests, a simple code coverage tool is provided, and you can see the results by opening the generated `coverage` folder.
