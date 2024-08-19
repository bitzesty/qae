class AssessorAssignmentPolicy < ApplicationPolicy
  def update?
    record.editable_for?(subject)
  end

  def submit?
    return true if admin_or_lead?

    record.assessor == subject || (
      primary? &&
      (record.primary? || record.case_summary?)
    )
  end

  def lead?
    subject.lead?(record.form_answer)
  end

  def primary?
    subject.primary?(record.form_answer)
  end

  def admin_or_lead?
    admin? || lead?
  end

  def can_be_submitted?
    submit? && !record.submitted?
  end

  def can_be_re_submitted?
    submit? && record.submitted? && !record.locked?
  end

  def can_unlock?
    record.locked? &&
      admin_or_lead?
  end
end
