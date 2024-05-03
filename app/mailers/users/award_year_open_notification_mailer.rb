class Users::AwardYearOpenNotificationMailer < ApplicationMailer
  def notify(user_id)
    @user = User.find(user_id)
    subject = "King's Awards for Enterprise Reminder: applications for the new Award year are open"

    send_mail_if_not_bounces ENV.fetch("GOV_UK_NOTIFY_API_TEMPLATE_ID", nil), to: @user.email,
                                                                              subject: subject_with_env_prefix(subject)
  end
end
