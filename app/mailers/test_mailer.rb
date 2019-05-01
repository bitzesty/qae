class TestMailer < ApplicationMailer
  def welcome(email)
    @email = email
    @subject = "[Queen's Awards for Enterprise] test mailer!"

    view_mail ENV['GOV_UK_NOTIFY_API_TEMPLATE_ID'], to: @email, subject: @subject
  end
end
