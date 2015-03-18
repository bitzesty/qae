class FlagPolicy < ApplicationPolicy
  def toggle?
    admin? || assessor?
  end
end
