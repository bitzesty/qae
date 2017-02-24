class PressSummary < ActiveRecord::Base
  belongs_to :form_answer

  validates :form_answer, :token, presence: true
  validates :body, presence: true, unless: :contact_details_update?
  validates :name,
            :email,
            :phone_number, presence: true,
                           if: :applicant_submitted?,
                           unless: :body_update?

  before_validation :set_token, on: :create

  belongs_to :authorable, polymorphic: true

  attr_accessor :contact_details_update, :body_update

  def contact_name
    name.to_s.strip.presence
  end

  private

  def set_token
    self.token = SecureRandom.urlsafe_base64(24)
  end

  def contact_details_update?
    contact_details_update.present?
  end

  def body_update?
    body_update.present?
  end
end
