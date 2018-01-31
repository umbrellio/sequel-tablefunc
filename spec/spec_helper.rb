require "bundler/setup"
require "sequel/extensions/tablefunc"

DB_NAME = (ENV['DB_NAME'] || "tablefunc_test").freeze

def connect
  Sequel.connect("postgres:///#{DB_NAME}").tap(&:tables)
rescue Sequel::DatabaseConnectionError => e
  raise unless e.message.include? "database \"#{DB_NAME}\" does not exist"
  #Sequel.connect('postgres:///postgres') do |connect|
  #  connect.run("create database #{DB_NAME}")
  #end
  `createdb #{DB_NAME}`
  Sequel.connect("postgres:///#{DB_NAME}")
end

DB = connect

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.before(:all) do
    DB.drop_table?(:data)
    DB.create_table?(:data) do
      primary_key :id
      String   :group
      String   :created_at
      Integer  :value
    end

    DB.run(<<~SQL)
      CREATE extension IF NOT EXISTS tablefunc;
    SQL

    data = YAML.load(IO.read("spec/fixtures/data.yml"))

    DB[:data].multi_insert(data)
  end

  config.after(:all) do
    DB.drop_table?(:data)
  end

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
