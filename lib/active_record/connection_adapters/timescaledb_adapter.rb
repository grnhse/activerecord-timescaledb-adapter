# frozen_string_literal: true

require "active_record"
require "active_record/connection_adapters/postgresql_adapter"
require "active_record/connection_adapters/timescaledb/version"

module ActiveRecord
  module ConnectionAdapters
    class TimescaleDBAdapter < PostgreSQLAdapter
      ADAPTER_NAME = "TimescaleDB"
    end
  end
end
