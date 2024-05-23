class CollaboratorPolicy < ApplicationPolicy
  def destroy?
    admin?
  end
end
