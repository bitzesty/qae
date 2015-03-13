class CommentPolicy < ApplicationPolicy
  def create?
    true # TODO: it's not true
  end

  def update?
    return true if admin?
    if assessor? && record.critical?
      subject.lead?(record.form_answer) ||
        subject.regular?(record.form_answer)
    end
  end

  def destroy?
    record.author?(subject)
  end
end
