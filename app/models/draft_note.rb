class DraftNote < ApplicationRecord
  validates :notable_type,
            :notable_id,
            :authorable_type,
            :authorable_id,
            presence: true

  belongs_to :notable, polymorphic: true, optional: true
  belongs_to :authorable, polymorphic: true, optional: true

  before_save :update_content_updated_at

  private

  def update_content_updated_at
    self.content_updated_at = DateTime.now
  end
end
