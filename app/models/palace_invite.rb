class PalaceInvite < ActiveRecord::Base
  belongs_to :form_answer

  has_many :palace_attendees, dependent: :destroy, autosave: true

  validates :form_answer, presence: true

  before_create :set_token

  private

  def set_token
    self.token = SecureRandom.base64(24)
  end
end
