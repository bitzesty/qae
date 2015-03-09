class NotificationPolicy < ApplicationPolicy
  def create?
    admin?
  end

  def update?
    !sent? && admin?
  end

  def destroy?
    !sent && admin?
  end
end
