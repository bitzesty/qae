class FormAnswerAttachmentPolicy < ApplicationPolicy
  # TODO: needs clarification

  def create?
    true
  end

  def show?
    true
  end

  def destroy?
    record.created_by_admin?
  end
end
