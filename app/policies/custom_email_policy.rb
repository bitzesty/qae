class CustomEmailPolicy < ApplicationPolicy
  def show?
    admin?
  end

  def create?
    admin?
  end
end
