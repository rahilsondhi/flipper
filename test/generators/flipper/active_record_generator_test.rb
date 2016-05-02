require 'helper'
require 'active_record'
require 'rails/generators/test_case'
require 'generators/flipper/active_record_generator'

class FlipperActiveRecordGeneratorTest < Rails::Generators::TestCase
  tests Flipper::Generators::ActiveRecordGenerator
  destination File.expand_path("../../../../tmp", __FILE__)
  setup :prepare_destination

  def test_generates_migration
    run_generator
    assert_migration "db/migrate/create_flipper_tables.rb", <<-EOM
class CreateFlipperTables < ActiveRecord::Migration
  def self.up
    create_table :flipper_features do |t|
      t.string :key, null: false
      t.timestamps null: false
    end
    add_index :flipper_features, :key, unique: true

    create_table :flipper_gates do |t|
      t.string :feature_key, null: false
      t.string :key, null: false
      t.string :value
      t.timestamps null: false
    end
    add_index :flipper_gates, [:feature_key, :key, :value], unique: true

    create_table :flipper_controls do |t|
      t.string :key, null: false
      t.string :value
      t.timestamps null: false
    end
    add_index :flipper_controls, [:key], unique: true
  end

  def self.down
    drop_table :flipper_gates
    drop_table :flipper_controls
    drop_table :flipper_features
  end
end
EOM
  end
end
