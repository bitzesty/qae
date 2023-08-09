class ShortlistedDocumentsWrapperPolicy < FormAnswerAttachmentPolicy
  def destroy?
    admin_or_lead_or_assigned?(record.form_answer)
  end

  def submit?
    admin_or_lead_or_assigned?(record.form_answer)
  end
end
