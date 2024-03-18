class AccountMailers::ReminderToSubmitMailer < AccountMailers::BaseMailer
  def notify(form_answer_id, collaborator_id)
    @form_answer = FormAnswer.find(form_answer_id)
    @user = @form_answer.user

    submission_deadline = Settings.current_submission_deadline
    deadline_time = formatted_deadline_time(submission_deadline)
    deadline_date = submission_deadline.trigger_at.strftime("%A, %d %B %Y")
    @deadline = "#{deadline_time} on #{deadline_date}"

    ordinal = submission_deadline.trigger_at.day.ordinal
    subject_deadline = submission_deadline.strftime("%e#{ordinal} %B")

    collaborator = User.find(collaborator_id)

    subject = "Complete your King's Award application by #{subject_deadline}"

    send_mail_if_not_bounces ENV['GOV_UK_NOTIFY_API_TEMPLATE_ID'], to: collaborator.email, subject: subject_with_env_prefix(subject)
  end
end
