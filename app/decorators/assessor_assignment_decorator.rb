class AssessorAssignmentDecorator < ApplicationDecorator
  def last_editor_info
    return unless object.assessed_at
    editor = object.editable
    if editor
      name = if editor.first_name.present? && editor.last_name.present?
        "#{editor.first_name} #{editor.last_name}"
      else
        "Anonymous"
      end

      "Updated by #{name} - #{l object.assessed_at, format: :date_at_time}"
    end
  end
end
