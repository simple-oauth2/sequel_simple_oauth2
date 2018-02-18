source 'https://rubygems.org'

gemspec

gem 'bcrypt'
gem 'sequel'

group :test do
  platforms :ruby, :mswin, :mswin64, :mingw, :x64_mingw do
    gem 'sqlite3'
  end

  gem 'rubocop', '~> 0.49.0', require: false

  gem 'codeclimate-test-reporter', '~> 1.0.0'
  gem 'coveralls', require: false
  gem 'database_cleaner', '~> 1.5.0'
  gem 'ffaker'
  gem 'rspec-rails', '~> 3.6'
  gem 'simplecov', require: false
end
