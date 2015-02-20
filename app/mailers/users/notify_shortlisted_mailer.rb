class Users::NotifyShortlistedMailer < ActionMailer::Base
  default from: "support@qae.co.uk"

  def notify(user)
    @user = user
    @subject = "[Queen's Awards for Enterprise] Congratulations! You've been shortlisted!"

    mail to: @user.email, subject: @subject
  end
end
