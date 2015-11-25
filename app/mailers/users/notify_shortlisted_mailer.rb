class Users::NotifyShortlistedMailer < AccountMailer
  def notify(form_answer_id)
    @form_answer = FormAnswer.find(form_answer_id).decorate
    @user = @form_answer.user.decorate
    @subject = "[Queen's Awards for Enterprise] Congratulations! You've been shortlisted!"
    @company_name = @form_answer.company_or_nominee_name

    # TODO - FIXME:
    #
    # @deadline = Settings.current.deadlines.where(kind: "audit_certificates").first
    # @deadline = @deadline.trigger_at.strftime("%d/%m/%Y")
    #
    #
    # for now deadline is harcoded

    @deadline = Date.new(2015, 12, 17).strftime("%d/%m/%Y")
    @award_type_full_name = @form_answer.award_type_full_name

    mail to: @user.email, subject: @subject
  end
end
