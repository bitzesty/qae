class Users::NotifyNonShortlistedMailer < ActionMailer::Base
  default from: "support@qae.co.uk"

  def notify(user)
    @user = user
    @subject = "[Queen's Awards for Enterprise] You have not been shortlisted this year"

    mail to: @user.email, subject: @subject
  end
end
