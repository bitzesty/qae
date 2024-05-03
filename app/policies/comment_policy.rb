class CommentPolicy < ApplicationPolicy
  def create?
    return true if admin?

    lead_or_assigned?
  end

  def update?
    return true if admin?

    lead_or_assigned?
  end

  def destroy?
    record.author?(subject)
  end

  private

  def lead_or_assigned?
    assessor? &&
      record.critical? &&
      subject.lead_or_assigned?(record.commentable)
  end
end
