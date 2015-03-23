class AssessorAssignmentDecorator < ApplicationDecorator
  def last_editor_info
    editor = object.editable
    if editor
      if editor.first_name.present? && editor.last_name.present?
        name = "#{editor.first_name} #{editor.last_name}"
      else
        name = "Anonymous"
      end

      "Updated by #{name} - #{l object.assessed_at, format: :date_at_time}"
    end
  end
end
