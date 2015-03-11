class AssessorAssignmentDecorator < ApplicationDecorator
  def last_editor_info
    editor = object.editable
    if editor
      "Updated by #{editor.first_name} #{editor.last_name} - #{object.assessed_at}"
    end
  end
end
