class PalaceAttendee < ApplicationRecord
  belongs_to :palace_invite

  validates :palace_invite,
            :title,
            :first_name,
            :last_name,
            :job_name,
            :address_1,
            :address_2,
            :postcode,
            presence: true
end
