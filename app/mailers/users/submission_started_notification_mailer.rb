class Users::SubmissionStartedNotificationMailer < ApplicationMailer
  def notify(user_id, award_type)
    @user = User.find(user_id)
    @award_type = FormAnswer::AWARD_TYPE_FULL_NAMES[award_type]
    subject = "Notification: applications for #{@award_type} Award are open"
    
    send_mail_if_not_bounces ENV["GOV_UK_NOTIFY_API_TEMPLATE_ID"], to: @user.email,
      subject: subject_with_env_prefix(subject)
  end
end
