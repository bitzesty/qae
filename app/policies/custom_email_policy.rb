class CustomEmailPolicy < ApplicationPolicy
  def show?
    admin?
  end
end
