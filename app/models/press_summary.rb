class PressSummary < ApplicationRecord
  belongs_to :form_answer, optional: true

  validates :form_answer, :token, presence: true
  validates :body, presence: true, unless: :contact_details_update?
  validates :name, :email, :phone_number,
            presence: true,
            unless: proc {|c| c.body_update.present?},
            if: :applicant_submitted?

  validates :title, :last_name,
            presence: true,
            unless: proc {|c| c.body_update.present? && form_answer.award_year.year >= 2020 },
            if: :applicant_submitted?

  before_validation :set_token, on: :create

  belongs_to :authorable, optional: true, polymorphic: true

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

  def set_press_contact_details_data_from_form
    doc = form_answer.document

    self.title = doc["press_contact_details_title"]
    self.name = doc["press_contact_details_first_name"]
    self.last_name = doc["press_contact_details_last_name"]
    self.phone_number = doc["press_contact_details_telephone"]
    self.email = doc["press_contact_details_email"]
  end
end
