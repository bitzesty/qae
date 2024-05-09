class PalaceInviteForm
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_reader :invite

  def initialize(invite)
    @invite = invite
  end

  def update(attributes = {})
    attributes.each do |k, v|
      public_send("#{k}=", v) if respond_to?("#{k}=")
    end

    if attributes[:submitted].present?
      if valid? && invite.save
        invite.update_column(:submitted, true)
      end
    else
      invite.save(validate: false)
    end
  end

  def valid?
    invite.valid? &&
      palace_attendees.count > 0 &&
      palace_attendees.count <= 2 &&
      palace_attendees.all?(&:valid?)
  end

  def palace_attendees
    @attendees ||= invite.palace_attendees.to_a
  end

  def build_palace_attendee
    @attendees ||= []
    @attendees << invite.palace_attendees.build
    @attendees.last
  end

  def persisted?
    false
  end

  def palace_attendees_attributes=(attrs = {})
    attrs.each do |(_, attendee_attributes)|
      attendee = if attendee_attributes["id"]
        palace_attendees.detect { |a| a.id.to_s == attendee_attributes["id"] }
      else
        build_palace_attendee
      end

      if attendee_attributes.keys.count == 1 &&
          attendee_attributes["id"].present?
        if attendee.persisted?
          attendee.mark_for_destruction
        else
          @attendees.pop
        end
      else
        attendee_attributes.delete("_remove")
        attendee.attributes = attendee_attributes
      end
    end
  end
end
