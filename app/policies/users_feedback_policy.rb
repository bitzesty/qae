class UsersFeedbackPolicy < ApplicationPolicy
  def show?
    admin?
  end
end
