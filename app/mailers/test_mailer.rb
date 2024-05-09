class TestMailer < ApplicationMailer
  def welcome(email)
    @email = email
    @subject = "[King's Awards for Enterprise] test mailer!"

    send_mail_if_not_bounces ENV["GOV_UK_NOTIFY_API_TEMPLATE_ID"], to: @email, subject: subject_with_env_prefix(@subject)
  end
end
