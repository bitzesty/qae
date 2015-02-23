class FormAnswerAttachmentPolicy < ApplicationPolicy
  def create?
    true
  end

  def show?
    true
  end

  def destroy?
    record.attachable.blank? || record.attachable_type == 'Admin'
  end
end
