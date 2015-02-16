require 'securerandom'

class Supporter < ActiveRecord::Base
  belongs_to :form_answer
  has_one :support_letter, dependent: :destroy

  validates :email, :form_answer, presence: true

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
