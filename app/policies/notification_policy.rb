class NotificationPolicy < ApplicationPolicy
  def create?
    admin?
  end
end
