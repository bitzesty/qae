class Users::SubmissionStartedNotificationMailer < ApplicationMailer
  def notify(user_id)
    @user = User.find(user_id)

    mail to: @user.email,
         subject: "Queen's Awards for Enterprise Reminder: applications for the new Award year are open"
  end
end
