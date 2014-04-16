class CreateActivityTables < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.belongs_to :done_by, index: true
      t.string :name
      t.datetime :created_at
    end

    create_table :versions do |t|
      t.belongs_to :trackable, :polymorphic => true
      t.string :event, :null => false
      t.belongs_to :activity, index: true
      t.belongs_to :done_by, index: true
      t.datetime :created_at
    end
    add_index :versions, [:trackable_type, :trackable_id]

    create_table :version_changes do |t|
      t.belongs_to :done_by, index: true
      t.belongs_to :version, index: true
      t.string :field, :null => false, index: true
      t.string :was
      t.string :now
    end
  end

  # Drop table
  def self.down
    drop_table :version_changes
    drop_table :versions
    drop_table :activities
  end
end