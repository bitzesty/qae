class FormAnswerPolicy < ApplicationPolicy
  def index?
    admin? || assessor?
  end

  def withdraw?
    admin?
  end

  def review?
    admin?
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
end
