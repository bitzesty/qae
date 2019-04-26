class Users::SubmissionStartedNotificationMailer < ApplicationMailer
  def notify(user_id, award_type)
    @user = User.find(user_id)
    @award_type = FormAnswer::AWARD_TYPE_FULL_NAMES[award_type]
    mail to: @user.email,
         subject: "Notification: applications for #{@award_type} Award are open"
  end
end
