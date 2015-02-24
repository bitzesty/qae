class FormAnswerAttachmentPolicy < ApplicationPolicy
  def create?
    true
  end

  def show?
    true
  end
end
