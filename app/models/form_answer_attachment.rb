class FormAnswerAttachment < ActiveRecord::Base

  belongs_to :form_answer
  belongs_to :attachable, polymorphic: true

  mount_uploader :file, FormAnswerAttachmentUploader
  scan_file      :file

  scope :uploaded_by_user, -> { where attachable_type: "User" }
  scope :uploaded_not_by_user, -> { where.not(attachable_type: "User") }

  # Used for NON JS implementation - begin
  attr_accessor :non_js_creation, :description
  # Should be 100 words maximum (limit + 10%).to_i + 1)
  validates :description, presence: true,
                          length: {
                            maximum: 111,
                            tokenizer: -> (str) { str.split },
                            message: "is too long (maximum is 100 words)"
                          },
                          on: :create,
                          if: "self.non_js_creation.present?"
  validate :question_key_correctness
  # Used for NON JS implementation - end

  begin :validations
    validates :form_answer_id, presence: true
    validates :file, presence: true,
                     file_size: {
                       maximum: 5.megabytes.to_i
                     }
  end

  def filename
    read_attribute(:file)
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
end
