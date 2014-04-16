class UserNotification < ActiveRecord::Base
  attr_accessible :read_at
  belongs_to :user
  belongs_to :version_change
  scope :for, ->(user) { where(user_id: user) }

  def mark_read!
    update_attribute :read_at, Time.zone.now
  end

  def self.mark_all_read_for(user)
    UserNotification.for(user, read_at: nil).update_all(read_at: Time.zone.now)
  end

  def self.mark_all_read_until(user, notification)
    UserNotification.for(user).where('id <= ?', notification).update_all(read_at: Time.zone.now)
  end
end