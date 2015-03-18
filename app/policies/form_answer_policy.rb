class FormAnswerPolicy < ApplicationPolicy
  def index?
    admin? || assessor?
  end

  def withdraw?
    admin?
  end

  def review?
    return true if admin?
    subject.lead_or_assigned?(record)
  end

  def show?
    admin? || assessor?
  end

  def update?
    admin?
  end

  def update_financials?
    true
  end

  def assign_assessor?
    admin? || subject.lead?(record)
  end

  def toggle_admin_flag?
    admin?
  end

  def toggle_assessor_flag?
    admin? || subject.lead_or_assigned?(record)
  end
end
