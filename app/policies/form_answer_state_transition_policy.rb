class FormAnswerStateTransitionPolicy < ApplicationPolicy
  def create?
    return true if admin?
    subject.lead?(record.form_answer)
  end
end
