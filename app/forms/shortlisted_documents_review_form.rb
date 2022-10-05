class ShortlistedDocumentsReviewForm
  include Virtus.model
  extend ActiveModel::Naming
  include ActiveModel::Conversion

  attribute :changes_description, String
  attribute :status, String
  attribute :form_answer_id, Integer

  attr_accessor :subject

  def persisted?
    false
  end

  def save
    docs = form_answer.shortlisted_documents_wrapper
    return false if docs.blank?

    docs.reviewable = subject
    docs.changes_description = changes_description
    docs.reviewed_at = DateTime.now
    docs.status = status
    docs.save
  end

  def form_answer
    @form_answer ||= FormAnswer.find(form_answer_id)
  end
end
