class AccountMailers::NotifyShortlistedMailer < AccountMailers::BaseMailer
  def notify(form_answer_id, collaborator_id)
    @form_answer = FormAnswer.find(form_answer_id).decorate
    @user = @form_answer.user.decorate
    collaborator = User.find(collaborator_id)

    @subject = "King's Awards for Enterprise: Congratulations, you've been shortlisted."
    @company_name = @form_answer.company_or_nominee_name

    @deadline = Settings.current.deadlines.where(kind: "audit_certificates").first
    @deadline_time = @deadline.trigger_at.strftime("%H:%M")
    @deadline_time = time_in_words(@deadline_time)
    @deadline_date = @deadline.trigger_at.strftime("%d/%m/%Y")

    @award_type_full_name = @form_answer.award_type_full_name

    send_mail_if_not_bounces ENV['GOV_UK_NOTIFY_API_TEMPLATE_ID'], to: collaborator.email, subject: subject_with_env_prefix(@subject)
  end

  def notify_po_sd(form_answer_id, collaborator_id)
    @form_answer = FormAnswer.find(form_answer_id).decorate
    @user = @form_answer.user.decorate
    collaborator = User.find(collaborator_id)

    @subject = "King's Awards for Enterprise: Congratulations, you've been shortlisted."

    @company_name = @form_answer.company_or_nominee_name

    @deadline = Settings.current.deadlines.where(kind: "audit_certificates").first
    @deadline_time = @deadline.trigger_at.strftime("%H:%M")
    @deadline_time = time_in_words(@deadline_time)
    @deadline_date = @deadline.trigger_at.strftime("%d/%m/%Y")

    @award_type_full_name = @form_answer.award_type_full_name

    send_mail_if_not_bounces ENV['GOV_UK_NOTIFY_API_TEMPLATE_ID'], to: collaborator.email, subject: subject_with_env_prefix(@subject)
  end

  def notify_po_sd_with_actual_figures(form_answer_id, collaborator_id)
    @form_answer = FormAnswer.find(form_answer_id).decorate
    @user = @form_answer.user.decorate
    collaborator = User.find(collaborator_id)

    @subject = "King's Awards for Enterprise: Congratulations, you've been shortlisted."

    @company_name = @form_answer.company_or_nominee_name

    @award_type_full_name = @form_answer.award_type_full_name

    send_mail_if_not_bounces ENV['GOV_UK_NOTIFY_API_TEMPLATE_ID'], to: collaborator.email, subject: subject_with_env_prefix(@subject)
  end

  def time_in_words time
    if time == "12:00"
      "noon"
    elsif time == "00:00"
      "midnight"
    else
      time
    end
  end
end
