class FlagPolicy < ApplicationPolicy
  def toggle?
    admin.admin?
  end
end
