class AssessorAssignmentPolicy < ApplicationPolicy
  def create?
    admin? || assessor?
  end

  def update?
    admin? || assessor?
  end
end
