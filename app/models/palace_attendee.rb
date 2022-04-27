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

  validates :has_royal_family_connections, inclusion: { in: [ true, false ] }

  validates :royal_family_connection_details, presence: true, if: :has_royal_family_connections?
end
