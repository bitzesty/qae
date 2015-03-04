require 'securerandom'

class Supporter < ActiveRecord::Base
  begin :associations
    belongs_to :form_answer
    belongs_to :user

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
  after_create :notify!

  private

  def generate_access_key
    self.access_key = SecureRandom.hex
  end

  def notify!
    Users::SupporterMailer.delay.success(self.id, form_answer.user.id)
  end
end
