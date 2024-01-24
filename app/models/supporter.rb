require 'securerandom'

class Supporter < ApplicationRecord
  begin :associations
    belongs_to :form_answer, optional: true
    belongs_to :user, optional: true

    has_one :support_letter, dependent: :destroy
  end

  begin :associations
    validates :email, :form_answer, presence: true
  end

  begin :validations
    validates :email, email: true

    validates :first_name,
              :last_name,
              :user,
              :form_answer,
              :relationship_to_nominee, presence: true
  end

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
