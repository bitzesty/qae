class PressSummary < ActiveRecord::Base
  belongs_to :form_answer

  validates :form_answer, :body, :token, presence: true
  validates :first_name, :last_name, :email, :phone_number, presence: true, if: :reviewed_by_user?

  before_validation :set_token, on: :create
  after_save :notify_applicant

  belongs_to :authorable, polymorphic: true

  private

  def set_token
    self.token = SecureRandom.base64(24)
  end

  def notify_applicant
    if approved_changed? && approved?
      Users::WinnersPressRelease.notify(form_answer.id).deliver_later!
    end
  end
end
