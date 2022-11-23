# frozen_string_literal: true

require "active_record"
require "active_support/concern"

module ActiveRecord
  module Timescale
    module SchemaMigration
      extend ActiveSupport::Concern

      # Create a Hypertable from a postgres table
      # An existing table can be used or, if given a block, a new table will be created.
      #
      # Examples:
      #
      # create_hyper_table :check_ins, time_column_name: 'checked_in_at', id: false do |t|
      #   t.references :user
      #   t.datetime :checked_in_at, null: false, index: true
      #   t.timestamps
      # end
      #
      # # check_ins table already exists
      # create_hyper_table :check_ins, time_column_name: 'checked_in_at', migrate_data: true
      #
      # # Simplest example
      # create_hyper_table :check_ins
      #
      # @param relation [String] Identifier of table to convert to hypertable.
      # @param options.time_column_name [String] Name of the column containing time values as well as the primary column to partition by.
      # @param options.partitioning_column [String, nil] Name of an additional column to partition by.
      # @param options.number_partitions [Integer, nil] Number of hash partitions to use for partitioning_column. Must be > 0. Default is the number of data_nodes.
      # @param options.chunk_time_interval [String, Integer, nil] Interval in event time that each chunk covers. Must be > 0. Default is 7 days.
      # @param options.create_default_indexes [Boolean, nil] Boolean whether to create default indexes on time/partitioning columns. Default is TRUE.
      # @param options.if_not_exists [Boolean, nil] Boolean whether to print warning if table already converted to hypertable or raise exception. Default is FALSE.
      # @param options.partitioning_func [String, nil] The function to use for calculating a value's partition.
      # @param options.associated_schema_name [String, nil] Name of the schema for internal hypertable tables. Default is _timescaledb_internal.
      # @param options.associated_table_prefix [String, nil] Prefix for internal hypertable chunk names. Default is _hyper.
      # @param options.migrate_data [Boolean, nil] Set to TRUE to migrate any existing data from the relation table to chunks in the new hypertable. A non-empty table generates an error without this option. Large tables may take significant time to migrate. Default is FALSE.
      # @param options.time_partitioning_func [String, nil] Function to convert incompatible primary time column values to compatible ones. The function must be IMMUTABLE.
      # @param options.replicator_factor [Integer, nil] The number of data nodes to which the same data is written to. This is done by creating chunk copies on this amount of data nodes. Must be >= 1; If not set, the default value is determined by the timescaledb.hypertable_replication_factor_default GUC.
      # @param options.data_nodes [Array<String>, nil] The set of data nodes used for the distributed hypertable. If not present, defaults to all data nodes known by the access node (the node on which the distributed hypertable is created).
      # @param options.distributed [Boolean, nil] Set to TRUE to create distributed hypertable. If not provided, value is determined by the timescaledb.hypertable_distributed_default GUC. When creating a distributed hypertable, consider using create_distributed_hypertable in place of create_hypertable. Default is NULL.
      def create_hyper_table(relation, time_column_name: "created_at", **options, &block)
        hyper_table_options = HyperTableOptions.new(**options)
        create_table(relation, **hyper_table_options.args, &block) unless block.nil?
        execute "SELECT create_hyper_table('#{relation}', '#{time_column_name}', #{hyper_table_options.to_sql})"
      end

      # See create_hyper_table for examples. Works exactly the same but the distributed option is forced to TRUE
      def create_distributed_hyper_table(relation, **options, &block)
        create_hyper_table(relation, **options.merge({distributed: true}), &block)
      end

      class HyperTableOptions
        def initialize(
          partitioning_column: nil,
          number_partitions: nil,
          chunk_time_interval: "7 days",
          create_default_indexes: true,
          if_not_exists: false,
          partitioning_func: nil,
          associated_schema_name: "_timescaledb_internal",
          associated_table_prefix: "_hyper",
          migrate_data: false,
          time_partitioning_func: nil,
          replicator_factor: nil,
          data_nodes: [],
          distributed: nil,
          **other_args
        )

          @partitioning_column = partitioning_column
          @number_partitions = number_partitions
          @chunk_time_interval = chunk_time_interval
          @create_default_indexes = create_default_indexes
          @if_not_exists = if_not_exists
          @partitioning_func = partitioning_func
          @associated_schema_name = associated_schema_name
          @associated_table_prefix = associated_table_prefix
          @migrate_data = migrate_data
          @time_partitioning_func = time_partitioning_func
          @replicator_factor = replicator_factor
          @data_nodes = data_nodes
          @distributed = distributed
          @other_args = other_args
        end

        def args
          @other_args.merge(
            {
              partitioning_column: @partitioning_column,
              number_partitions: @number_partitions,
              chunk_time_interval: @chunk_time_interval,
              create_default_indexes: @create_default_indexes,
              if_not_exists: @if_not_exists,
              partitioning_func: @partitioning_func,
              associated_schema_name: @associated_schema_name,
              associated_table_prefix: @associated_table_prefix,
              migrate_data: @migrate_data,
              time_partitioning_func: @time_partitioning_func,
              replicator_factor: @replicator_factor,
              data_nodes: @data_nodes,
              distributed: @distributed
            }
          )
        end

        def to_sql
          sql = []
          sql << "partitioning_column => '#{@partioning_column}'" unless @partitioning_column.nil?
          sql << "number_partitions => #{@number_partitions}" unless @number_partitions.nil?
          sql << "if_not_exists => #{@if_not_exists}"
          sql << "partitioning_func => '#{@partitioning_func}'" unless @partitioning_func.nil?
          sql << "associated_schema_name => '#{@associated_schema_name}'"
          sql << "associated_table_prefix => '#{@associated_table_prefix}'"
          sql << "migrate_date => #{@migrate_data}"
          sql << "time_partitioning_func => '#{@time_partitioning_func}'" unless @time_partitioning_func.nil?
          sql << "replicator_factor => #{@replicator_factor}" unless @replicator_factor.nil?
          sql << "data_nodes => '{ #{@data_nodes.join(", ")} }'" if @data_nodes.any?
          sql << "disstributed => #{@distributed}" unless @distributed.nil?
          sql <<
            if @chunk_time_interval.is_a? String
              "chunk_time_interval => INTERVAL '#{@chunk_time_interval}'"
            else
              "chunk_time_interval => #{@chunk_time_interval}"
            end

          sql.join(", ")
        end
      end
    end
  end
end

ActiveRecord::Migration.send(:include, ActiveRecord::Timescale::SchemaMigration)
