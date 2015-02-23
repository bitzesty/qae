class NotificationPolicy < ApplicationPolicy
  def create?
    admin.admin?
  end
end
