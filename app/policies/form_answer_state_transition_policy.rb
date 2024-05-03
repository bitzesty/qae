class FormAnswerStateTransitionPolicy < ApplicationPolicy
  def create?
    return true if admin?
    return true if record.state == "assessment_in_progress"

    subject.lead?(record.form_answer)
  end

  def view_dropdown?
    return true if admin?
    return true if record.state == "submitted"

    subject.lead?(record.form_answer)
  end
end
