class AccountMailers::NotifyShortlistedMailer < AccountMailers::BaseMailer
  def notify(form_answer_id, collaborator_id)
    @form_answer = FormAnswer.find(form_answer_id).decorate
    @user = @form_answer.user.decorate
    collaborator = User.find(collaborator_id)

    @subject = "[Queen's Awards for Enterprise] Congratulations! You've been shortlisted!"
    @company_name = @form_answer.company_or_nominee_name

    @deadline = Settings.current.deadlines.where(kind: "audit_certificates").first
    @deadline_time = @deadline.trigger_at.strftime("%H:%M")
    @deadline_date = @deadline.trigger_at.strftime("%d/%m/%Y")

    @award_type_full_name = @form_answer.award_type_full_name

    view_mail ENV['GOV_UK_NOTIFY_API_TEMPLATE_ID'], to: collaborator.email, subject: @subject
  end
end
