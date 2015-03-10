class AssessmentSubmissionPolicy < ApplicationPolicy
  def create?
    return true if admin?
    return false unless assessor?
    record.assessor == subject || subject.lead?(record.form_answer)
  end
end
