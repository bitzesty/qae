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

    invite.save if valid?
  end

  def valid?
    invite.valid? && palace_attendees.all?(&:valid?)
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

      if attendee_attributes.delete("_remove") == "1"
        if attendee.persisted?
          attendee.mark_for_destruction
        else
          @attendees.pop
        end
      else
        attendee.attributes = attendee_attributes
      end
    end
  end
end
