class EmailNotificationPolicy < ApplicationPolicy
  def create?
    admin?
  end

  def update?
    !record.sent? && admin?
  end

  def destroy?
    !record.sent? && admin?
  end
end
