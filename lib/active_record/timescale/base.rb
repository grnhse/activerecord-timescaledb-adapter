# frozen_string_literal: true

module ActiveRecord
  module Timescale
    class Base < ActiveRecord::Base
      # The first aggregate allows you to get the value of one column as ordered by another.
      # For example, first(temperature, time) returns the earliest temperature
      # value based on time within an aggregate group.
      #
      # The last aggregate allows you to get the value of one column as ordered by another.
      # For example, last(temperature, time) returns the latest temperature
      # value based on time within an aggregate group.
      %i[first last].each do |method|
        scope method, lambda do |value, time|
          select(sanitize_sql(["#{method}(?, ?)", value, time]))
        end
      end

      # @param value [*] A set of values to partition into a histogram
      # @param min [Integer] The histogram's lower bound used in bucketing (inclusive)
      # @param max [Integer] The histogram's upper bound used in bucketing (exclusive)
      # @param npartitions [Integer] The integer value for the number of histogram buckets (partitions)
      scope :histogram, lambda do |value, min, max, nbuckets|
        select(sanitize_sql(["historgram(?, ?, ?, ?)", value, min, max, nbuckets]))
      end

      class << self
        # Get approximate row count for hypertable, distributed hypertable, or regular
        # PostgreSQL table based on catalog estimates. This function supports tables
        # with nested inheritance and declarative partitioning.
        #
        # The accuracy of approximate_row_count depends on the database having up-to-date statistics about
        # the table or hypertable, which are updated by VACUUM, ANALYZE, and a few DDL commands.
        # If you have auto-vacuum configured on your table or hypertable, or changes to the
        # table are relatively infrequent, you might not need to explicitly ANALYZE your table as shown below.
        # Otherwise, if your table statistics are too out-of-date, running this command updates
        # your statistics and yields more accurate approximation results.
        def approximate_row_count
          execute sanitize_sql(["SELECT * FROM approximate_row_count(?)", quote_table_name(table_name)])
        end
      end
    end
  end
end
