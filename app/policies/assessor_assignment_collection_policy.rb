class AssessorAssignmentCollectionPolicy < ApplicationPolicy
  def create?
    admin? || assessor?
  end
end
