class FlagPolicy < ApplicationPolicy
  def toggle?
    admin?
  end
end
