class FormAnswerPolicy < ApplicationPolicy
  def index?
    admin.admin?
  end

  def withdraw?
    admin.admin?
  end

  def review?
    admin.admin?
  end

  def show?
    admin.admin?
  end

  def update_financials?
    true
  end
end
