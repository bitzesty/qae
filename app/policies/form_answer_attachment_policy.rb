class FormAnswerAttachmentPolicy < ApplicationPolicy
  def create?
    admin_or_lead_or_assigned?(record.form_answer)
  end

  def show?
    admin_or_lead_or_assigned?(record.form_answer)
  end

  def destroy?
    (admin? && record.created_by_admin?) ||
      (assessor? && record.attachable == subject)
  end
end
