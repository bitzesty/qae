class Users::SubmissionStartedNotificationMailer < ApplicationMailer
  def notify(user_id, award_type)
    @user = User.find(user_id)
    @award_type = FormAnswer::AWARD_TYPE_FULL_NAMES[award_type]
    view_mail ENV['GOV_UK_NOTIFY_API_TEMPLATE_ID'], to: @user.email,
         subject: "Notification: applications for #{@award_type} Award are open"
  end
end
