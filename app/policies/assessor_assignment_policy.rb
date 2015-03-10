class AssessorAssignmentPolicy < ApplicationPolicy
  def create?
    admin? || assessor?
  end

  def update?
    admin? || assessor?
  end

  def submit?
    return true if admin?
    return false unless assessor?
    record.assessor == subject || subject.lead?(record.form_answer)
  end
end
