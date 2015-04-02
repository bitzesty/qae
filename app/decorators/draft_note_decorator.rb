class DraftNoteDecorator < ApplicationDecorator
  def last_updated_by
    name = object.authorable.decorate.full_name if object.authorable.present?
    time = object.content_updated_at.try(:strftime, "%e %b %Y at %H:%M")
    "Updated by #{name} - #{time}" if name && time
  end
end
