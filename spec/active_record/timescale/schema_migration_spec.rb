# frozen_string_literal: true

require "spec_helper"
require "migration_helper"
require "active_record/timescale/schema_migration"

module ActiveRecord
  module Timescale
    RSpec.describe SchemaMigration do
      include MigrationHelper

      before(:context) do
        self.migration_class = ActiveRecord::Migration[4.2]
      end

      after(:context) do
        self.migration_class = nil
      end

      describe "#create_hyper_table" do
        it "creates a table if a block is given" do
          migrate do
            allow(self).to receive(:create_table)
            allow(self).to receive(:create_hyper_table).and_call_original
            expect(self).to receive(:create_table).once

            create_hyper_table :check_ins, time_column_name: "checked_in_at", id: false do |table|
              table.datetime :checkd_in_at, null: false, index: true
              table.timestamps
            end
          end
        end

        it "does not create a table if a block is not given" do
          migrate do
            allow(self).to receive(:create_table)
            allow(self).to receive(:create_hyper_table).and_call_original
            expect(self).not_to receive(:create_table)

            create_hyper_table :check_ins, time_column_name: "checked_in_at"
          end
        end
      end

      describe "#create_distributed_hyper_table" do
        it "calls create_hyper_table with distributed set to true" do
          migrate do
            allow(self).to receive(:create_hyper_table)
            allow(self).to receive(:create_distributed_hyper_table).and_call_original
            expect(self)
              .to receive(:create_hyper_table)
              .with(:check_ins, time_column_name: "checked_in_at", distributed: true)
              .once

            create_distributed_hyper_table :check_ins, time_column_name: "checked_in_at"
          end
        end

        it "cannot force distributed to be false" do
          migrate do
            allow(self).to receive(:create_hyper_table)
            allow(self).to receive(:create_distributed_hyper_table).and_call_original
            expect(self)
              .to receive(:create_hyper_table)
              .with(:check_ins, time_column_name: "checked_in_at", distributed: true)
              .once

            create_distributed_hyper_table :check_ins, time_column_name: "checked_in_at", distributed: false
          end
        end
      end
    end
  end
end
