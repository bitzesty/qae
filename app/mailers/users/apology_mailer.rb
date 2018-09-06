class Users::ApologyMailer < ApplicationMailer
  def notify(user_id)
    @user = User.find(user_id)
    @subject = "Queen's Awards for Enterprise: Multiple reminders sent by mistake"

    mail to: @user.email, subject: @subject
  end
end
