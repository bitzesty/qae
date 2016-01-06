class AssessorAssignmentPolicy < ApplicationPolicy
  def update?
    record.editable_for?(subject)
  end

  def submit?
    return true if admin?
    return false unless assessor?
    lead? || primary?
  end

  def lead?
    record.assessor == subject || subject.lead?(record.form_answer)
  end

  def primary?
    record.assessor == subject || subject.primary?(record.form_answer)
  end

  def can_be_submitted?
    submit? && !record.submitted?
  end

  def can_be_re_submitted?
    !record.locked? &&
    submit? &&
    record.submitted? &&
    record.case_summary?
  end

  def can_unlock?
    record.locked? &&
    record.case_summary? &&
    (admin? || (assessor? && lead?))
  end
end
