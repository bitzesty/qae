class TestMailer < ActionMailer::Base
  default from: "support@qae.co.uk"

  def welcome(email)
    @email = email
    @subject = "[Queen's Awards for Enterprise] test mailer!"

    mail to: @email, subject: @subject
  end
end
