require 'fake/active_record/config'
require 'auditlog/model_tracker'
# models
class User < ActiveRecord::Base
  include Auditlog::ModelTracker
  track
  attr_accessible :email, :name
end

class Task < ActiveRecord::Base
  include Auditlog::ModelTracker
  track only: [:title, :hours_estimated, :assigned_to_id], except: [:id]

  attr_accessible :title, :hours_estimated, :assigned_to_id
end

class Story < ActiveRecord::Base
  attr_accessible :title, :assigned_to_id, :hours_estimated
end

#migrations
class CreateAllTables < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.string "name"
      t.string "email"
    end

    create_table "stories", :force => true do |t|
      t.string "title"
      t.string "status"
      t.integer "assigned_to_id"
      t.float "hours_estimated"
    end

    create_table "tasks", :force => true do |t|
      t.string "title"
      t.string "status"
      t.integer "story_id"
      t.integer "assigned_to_id"
      t.float "hours_estimated"
    end

    create_table :activities do |t|
      t.belongs_to :done_by
      t.string :name
      t.datetime :created_at
    end

    create_table :versions do |t|
      t.belongs_to :trackable, :polymorphic => true
      t.string :event, :null => false
      t.belongs_to :done_by
      t.belongs_to :activity
      t.datetime :created_at
    end

    create_table :version_changes do |t|
      t.belongs_to :version
      t.string :field, :null => false
      t.string :was
      t.string :now
    end
  end
end
ActiveRecord::Migration.verbose = false
CreateAllTables.up