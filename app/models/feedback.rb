class Feedback < ActiveRecord::Base
  belongs_to :form_answer

  store_accessor :document, FeedbackForm.fields

  scope :submitted, -> { where submitted: true }
  belongs_to :authorable, polymorphic: true
  belongs_to :award_year

  validates :form_answer_id, uniqueness: true

  before_create :set_award_year!

  def locked?
    locked_at.present?
  end

  private

  def set_award_year!
    self.award_year = form_answer.award_year
  end
end
