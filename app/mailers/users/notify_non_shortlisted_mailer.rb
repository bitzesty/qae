class Users::NotifyNonShortlistedMailer < ApplicationMailer
  def notify(user)
    @user = user
    @subject = "[Queen's Awards for Enterprise] You have not been shortlisted this year"

    mail to: @user.email, subject: @subject
  end
end
