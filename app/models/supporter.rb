require 'securerandom'

class Supporter < ActiveRecord::Base
  belongs_to :form_answer
  has_one :support_letter, dependent: :destroy

  validates :email, :form_answer, :access_key, presence: true

  before_validation :generate_access_key

  private

  def generate_access_key
    self.access_key = SecureRandom.hex
  end
end
