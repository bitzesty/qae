class  Users::CommercialFiguresMailer < ApplicationMailer
  def notify(form_answer_id, user_id)
    @form_answer = FormAnswer.find(form_answer_id).decorate
    @recipient = User.find(user_id).decorate

    subject = "Queen's Awards for Enterprise: Latest financial information has been submitted"
    send_mail_if_not_bounces ENV['GOV_UK_NOTIFY_API_TEMPLATE_ID'], to: @recipient.email, subject: subject_with_env_prefix(subject)
  end
end
