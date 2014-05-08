# String to symbol regex :(.*) ==> :$1
require 'auditlog/model_tracker'

class User < ActiveRecord::Base
  include Auditlog::ModelTracker
  track only: [:first_name, :last_name]
end

class WorkflowStatus < ActiveRecord::Base
  include Auditlog::ModelTracker
end

class Project < ActiveRecord::Base
end

class Story < ActiveRecord::Base
  include Auditlog::ModelTracker
  has_many :tasks
  belongs_to :workflow_status
  belongs_to :project
  belongs_to :assigned_to, :class_name => "User", :foreign_key => "assigned_to_id"
end

class Task < ActiveRecord::Base
  include Auditlog::ModelTracker
  belongs_to :story
  belongs_to :workflow_status
  belongs_to :assigned_to, :class_name => "User", :foreign_key => "assigned_to_id"

  track only: [:title, :status, :hours_estimated, :assigned_to_id, :workflow_status_id], meta: [:project_id]
end

class Comment < ActiveRecord::Base
  include Auditlog::ModelTracker
  belongs_to :user
  belongs_to :commentable, :polymorphic => true
end

class Comment < ActiveRecord::Base
  include Auditlog::ModelTracker
  belongs_to :user
  belongs_to :commentable, :polymorphic => true
end

#migrations
class CreateAllTables < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
    end

    create_table :projects, force: true do |t|
      t.string   :name
    end

    create_table :stories do |t|
      t.string :title
      t.integer :assigned_to_id
      t.date :deadline
      t.integer :workflow_status_id
    end

    create_table :tasks do |t|
      t.string :title
      t.integer :story_id
      t.integer :assigned_to_id
      t.integer :workflow_status_id
    end

    create_table :comments do |t|
      t.text :text
      t.integer :user_id
      t.integer :commentable_id
      t.string :commentable_type
    end

    create_table :workflow_statuses do |t|
      t.string :title
    end

    create_table :activities do |t|
      t.belongs_to :done_by
      t.string :name
      t.datetime :created_at
    end

    create_table :versions do |t|
      t.belongs_to :trackable, :polymorphic => true
      t.string :event, :null => false
      t.belongs_to :activity
      t.belongs_to :done_by
      t.belongs_to :project
      t.datetime :created_at
    end

    create_table :version_changes do |t|
      t.belongs_to :version
      t.string :field, :null => false
      t.string :was
      t.string :now
    end

    create_table :auditlog_change_notifications do |t|
      t.references :model, :polymorphic => true
      t.references :version, :null => false
    end
  end
end
ActiveRecord::Migration.verbose = false
CreateAllTables.up