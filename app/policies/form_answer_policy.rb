class FormAnswerPolicy < ApplicationPolicy
  def index?
    admin?
  end

  def withdraw?
    admin?
  end

  def review?
    admin?
  end

  def show?
    admin?
  end

  def update?
    admin?
  end

  def update_financials?
    true
  end
end
