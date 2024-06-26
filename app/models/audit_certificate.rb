class AuditCertificate < ApplicationRecord
  include ShortlistedDocument
  include Reviewable

  validates :attachment, presence: true,
    on: :create,
    file_size: {
      maximum: 15.megabytes.to_i,
    }

  validates :form_answer_id, uniqueness: true, presence: true # rubocop:disable Rails/UniqueValidationWithoutIndex

  before_save :clean_changes_description

  enum status: {
    no_changes_necessary: 0,
    confirmed_changes: 1,
  }

  private

  def clean_changes_description
    if status_changed? && status == "no_changes_necessary" && changes_description.present?
      self.changes_description = nil
    end
  end
end
