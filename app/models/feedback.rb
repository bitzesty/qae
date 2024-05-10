class Feedback < ApplicationRecord
  has_paper_trail unless: Proc.new { |t| Rails.env.test? }

  belongs_to :form_answer, optional: true

  store_accessor :document, FeedbackForm.fields

  scope :submitted, -> { where submitted: true }
  belongs_to :authorable, polymorphic: true, optional: true
  belongs_to :award_year, optional: true

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
