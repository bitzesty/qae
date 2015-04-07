class PalaceAttendee < ActiveRecord::Base
  belongs_to :palace_invite

  validates :palace_invite,
            :title,
            :first_name,
            :last_name,
            :job_name,
            :post_nominals,
            :address_1,
            :address_2,
            :address_3,
            :address_4,
            :postcode,
            presence: true
end
