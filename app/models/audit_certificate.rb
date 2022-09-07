class AuditCertificate < ActiveRecord::Base
  include ShortlistedDocument

  begin :associations
    belongs_to :reviewable, polymorphic: true
  end

  begin :validations
    validates :attachment, presence: true,
                           on: :create,
                           file_size: {
                             maximum: 10.megabytes.to_i
                           }
    validates :reviewable_type,
              :reviewable_id,
              :reviewed_at,
              presence: true,
              if: :reviewed?

    validates :form_answer_id, uniqueness: true,
              presence: true
  end

  before_save :clean_changes_description

  enum status: {
    no_changes_necessary: 0,
    confirmed_changes: 1
  }

  def reviewed?
    reviewed_at.present?
  end

  private

  def clean_changes_description
    if status_changed? && status == "no_changes_necessary" && changes_description.present?
      self.changes_description = nil
    end
  end
end
