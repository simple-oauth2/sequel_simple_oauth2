ENV['RACK_ENV'] = 'test'

if RUBY_VERSION >= '1.9'
  require 'simplecov'
  require 'coveralls'

  SimpleCov.formatters = [
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
  ]

  SimpleCov.start do
    add_filter '/spec/'
    minimum_coverage(90)
  end
end

require 'ffaker'
require 'sequel'
require 'database_cleaner'

require_relative '../config/db'
require File.expand_path('../../lib/sequel_simple_oauth2', __FILE__)
require 'support/access_grant'
require 'support/access_token'
require 'support/client'
require 'support/user'

RSpec.configure do |config|
  config.order = :random
  config.color = true

  config.before(:suite) do
    DatabaseCleaner[:sequel].strategy = :truncation
    DatabaseCleaner[:sequel].clean_with(:truncation)
  end

  config.before do
    DatabaseCleaner[:sequel].start
  end

  config.after do
    DatabaseCleaner[:sequel].clean
  end
end
