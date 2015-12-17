class AssessorAssignmentPolicy < ApplicationPolicy
  def update?
    record.editable_for?(subject)
  end

  def submit?
    return true if admin?
    return false unless assessor?
    record.assessor == subject ||
      subject.lead?(record.form_answer)
  end

  def can_be_submitted?
    submit? && !record.submitted?
  end

  def can_be_re_submitted?
    submit? && record.submitted? && record.case_summary?
  end
end
