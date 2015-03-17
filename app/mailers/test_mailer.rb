class TestMailer < ApplicationMailer
  def welcome(email)
    @email = email
    @subject = "[Queen's Awards for Enterprise] test mailer!"

    mail to: @email, subject: @subject
  end
end
