# frozen_string_literal: true

require "active_record/connection_adapters/timescaledb_adapter"
require "nulldb/core"
require "pry"

RSpec.configure do |config|
  NullDB.configure do |c|
    c.project_root = File.expand_path("..", __dir__)
  end
  ActiveRecord::Base.establish_connection adapter: :nulldb, schema: "spec/support/db/schema.rb"

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
