class CommentPolicy < ApplicationPolicy
  def create?; true; end

  def update?; true; end

  def destroy?
    record.author?(admin)
  end
end
