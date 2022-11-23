# frozen_string_literal: true

module MigrationHelper
  def migration_class=(migration_class_under_test)
    @migration_class = migration_class_under_test
  end

  def expect_migration_success(&block)
    expect { migrate(&block) }.not_to raise_error
  end

  def migration_class(&block)
    rspec = self

    new_class = Class.new(@migration_class)
    new_class.send(:define_method, :change, &block)

    %i[allow receive expect].each do |method|
      new_class.define_method(method) do |*args|
        rspec.send(method, *args)
      end
    end

    new_class
  end

  def migrate(&block)
    migration_class(&block).new.migrate(:up)
  end
end
