class DeadlinePolicy < ApplicationPolicy
  def update?
    admin?
  end
end
