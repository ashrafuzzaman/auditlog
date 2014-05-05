class AuditlogChangeNotification < ActiveRecord::Base
  belongs_to :version_change
  belongs_to :model, polymorphic: true

  validates :model_type, :model_id, :version_change_id, presence: true
end