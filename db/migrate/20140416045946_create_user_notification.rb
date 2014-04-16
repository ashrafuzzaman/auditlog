class CreateUserNotification < ActiveRecord::Migration
  def change
    create_table :user_notifications do |t|
      t.references :user, index: true
      t.references :version_change, index: true
      t.datetime :read_at
    end
  end
end
