class PalaceInvite < ApplicationRecord
  belongs_to :form_answer, optional: true

  has_many :palace_attendees, dependent: :destroy, autosave: true

  validates :form_answer_id, presence: true,
                             uniqueness: true

  before_create :set_token

  def prebuild_if_necessary
    attendees = palace_attendees
    records = attendees.select { |a| !a.new_record? }
    unless records.size == attendees_limit
      to_build = attendees_limit - records.size
      to_build.times do
        palace_attendees.build
      end
    end
    self
  end

  def submit!
    self.submitted = true
    save
  end

  def attendees_limit
    if form_answer.promotion?
      1 # nominator
    else
      1 # 2020 COVID inspired rules
    end
  end

  private

  def set_token
    self.token = SecureRandom.urlsafe_base64(24)
  end
end
