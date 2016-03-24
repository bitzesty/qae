class Feedback < ActiveRecord::Base
  belongs_to :form_answer

  store_accessor :document, FeedbackForm.fields

  scope :submitted, -> { where submitted: true }
  belongs_to :authorable, polymorphic: true

  validates :form_answer_id, uniqueness: true

  def locked?
    locked_at.present?
  end
end
