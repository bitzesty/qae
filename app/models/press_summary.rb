class PressSummary < ActiveRecord::Base
  belongs_to :form_answer

  validates :form_answer, :body, presence: true

  after_save :notify_applicant

  private

  def notify_applicant
    if approved_changed? && approved?
      Users::WinnersPressRelease.notify(form_answer.id).deliver_later!
    end
  end
end
