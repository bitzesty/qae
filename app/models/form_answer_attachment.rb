class FormAnswerAttachment < ApplicationRecord
  include ScanFiles
  belongs_to :form_answer, optional: true
  belongs_to :attachable, polymorphic: true, optional: true

  mount_uploader :file, FormAnswerAttachmentUploader

  scan_for_viruses :file

  scope :uploaded_by_user, -> { where attachable_type: "User" }
  scope :uploaded_not_by_user, -> { where.not(attachable_type: "User") }

  # Used for NON JS implementation - begin
  attr_accessor :non_js_creation, :description
  # Should be 100 words maximum (limit + 10%).to_i + 1)
  validates :description, presence: true,
    on: :create,
    if: -> { non_js_creation.present? }

  validate :words_in_description, on: :create,
    if: -> { description.present? && non_js_creation.present? }

  validate :question_key_correctness
  # Used for NON JS implementation - end

  validates :form_answer_id, presence: true
  validates :file, presence: true,
    on: :create,
    file_size: { maximum: 5.megabytes.to_i }

  def filename
    self[:file]
  end

  def created_by_admin?
    attachable.blank? || attachable.is_a?(Admin)
  end

  def self.visible_for(subject)
    out = all
    out = all.where(restricted_to_admin: false) unless subject.is_a?(Admin)
    out
  end

  def uploaded_not_by_user?
    attachable_type != "User"
  end

  private

  def question_key_correctness
    # possible improvements:
    # - validating all upload questions in this way
    # - smart collecting max-attachments information from the form structure
    if question_key == "org_chart" && new_record?
      if self.class.where(question_key: question_key, form_answer_id: form_answer_id).count > 0
        errors.add(:base, "Maximum amount of these kind of files reached.")
      end
    end
  end

  def words_in_description
    if description.split.size > 100
      errors.add(:description, message: "is too long (maximum is 100 words)")
    end
  end
end
