class PalaceAttendee < ApplicationRecord
  belongs_to :palace_invite, optional: true

  validates :palace_invite,
            :title,
            :first_name,
            :last_name,
            :job_name,
            :address_1,
            :address_2,
            :postcode,
            presence: true

  validates :disabled_access, inclusion: { in: [true, false], message: "This field cannot be blank" }
  validates :has_royal_family_connections, inclusion: { in: [true, false], message: "This field cannot be blank" }

  validates :royal_family_connection_details, presence: true, if: :has_royal_family_connections?
  validate :royal_family_connection_details_length

  private

  def royal_family_connection_details_length
    return if royal_family_connection_details.blank?
    return unless has_royal_family_connections?

    return unless royal_family_connection_details.split.size > 100

    errors.add(:royal_family_connection_details, message: "Exceeded 100 words limit.")
  end
end
