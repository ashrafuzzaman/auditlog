require 'auditlog/data'

class Version < ActiveRecord::Base
  attr_accessible :event, :done_by_id, :object

  belongs_to :activity
  belongs_to :trackable, polymorphic: true
  belongs_to :done_by, class_name: 'User'
  has_many :version_changes, dependent: :destroy

  before_save :set_done_by_id

  private
  def set_done_by_id
    self.done_by_id = Auditlog::Data.current_user_id
  end
end