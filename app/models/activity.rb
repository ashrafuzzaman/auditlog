class Activity < ActiveRecord::Base
  attr_accessible :name, :done_by_id

  belongs_to :done_by, class_name: 'User'
  before_save :set_done_by_id
  has_many :versions, dependent: :destroy

  private
  def set_done_by_id
    self.done_by_id = Auditlog::Data.current_user_id
  end
end