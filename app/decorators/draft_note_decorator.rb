class DraftNoteDecorator < ApplicationDecorator
  def last_updated_by
    return if object.content_updated_at.blank?

    name = object.authorable.decorate.full_name if object.authorable.present?
    time = l object.content_updated_at, format: :date_at_time
    "Updated by #{name} - #{time}" if name && time
  end
end
