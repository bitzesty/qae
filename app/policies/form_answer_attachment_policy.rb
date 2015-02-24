class FormAnswerAttachmentPolicy < ApplicationPolicy
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
