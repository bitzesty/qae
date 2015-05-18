class ReviewAuditCertificate
  include Virtus.model
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attribute :changes_description, String
  attribute :status, String
  attribute :form_answer_id, Integer

  attr_accessor :subject

  def persisted?
    false
  end

  def save
    audit = form_answer.audit_certificate
    return false if audit.blank?

    audit.reviewable = subject
    audit.changes_description = changes_description
    audit.reviewed_at = DateTime.now
    audit.status = status
    audit.save
  end

  def form_answer
    @form_answer ||= FormAnswer.find(form_answer_id)
  end
end
