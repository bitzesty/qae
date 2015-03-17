class Users::NotifyShortlistedMailer < ApplicationMailer
  def notify(user)
    @user = user
    @subject = "[Queen's Awards for Enterprise] Congratulations! You've been shortlisted!"

    mail to: @user.email, subject: @subject
  end
end
