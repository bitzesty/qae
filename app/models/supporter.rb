require "securerandom"

class Supporter < ApplicationRecord
  # associations
  belongs_to :form_answer, optional: true
  belongs_to :user, optional: true

  has_one :support_letter, dependent: :destroy

  # validations
  validates :email, email: true
  validates :email,
    :first_name,
    :last_name,
    :user,
    :form_answer,
    :relationship_to_nominee, presence: true

  before_create :generate_access_key
  after_create :notify!, unless: proc { Rails.env.test? }

  private

  def generate_access_key
    self.access_key = SecureRandom.hex
  end

  def notify!
    Users::SupporterMailer.success(self.id, form_answer.user.id).deliver_later!
  end
end
