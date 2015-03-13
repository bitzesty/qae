class CommentPolicy < ApplicationPolicy
  def create?
    true # TODO: it's not true
  end

  def update?
    return true if admin?
    if assessor? && record.critical?
      subject.lead?(record.commentable) ||
        subject.regular?(record.commentable)
    end
  end

  def destroy?
    record.author?(subject)
  end
end
