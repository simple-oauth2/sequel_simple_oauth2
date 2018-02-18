ENV['RACK_ENV'] = 'test'

require 'bundler/setup'
require 'rspec/core/rake_task'
require 'sequel'

desc 'Default: run specs.'
task default: :spec

namespace :db do
  namespace :test do
    task :prepare do
      ENV['RACK_ENV'] = 'test'
      require_relative 'config/db'
      Sequel.extension(:migration)
      Sequel::Migrator.run(DB, 'db/migrations', use_transactions: false)
      puts '<= db:migrate:up executed'
    end
  end
end

RSpec::Core::RakeTask.new(:spec) do |config|
  config.verbose = false
end

Bundler::GemHelper.install_tasks
