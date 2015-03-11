class AssessorAssignmentPolicy < ApplicationPolicy
  def update?
    record.editable_for?(subject)
  end

  def submit?
    return true if admin?
    return false unless assessor?
    record.assessor == subject || subject.lead?(record.form_answer)
  end
end
