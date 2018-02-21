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
require 'bcrypt'
require 'database_cleaner'

require_relative '../config/db'
require File.expand_path('../../lib/sequel_simple_oauth2', __FILE__)
require 'support/mixins/access_grant'
require 'support/mixins/access_token'
require 'support/mixins/client'
require 'support/mixins/user'
require 'support/generate_password'

RSpec.configure do |config|
  config.include Resource::GeneratePassword

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
