class Users::ImportMailer < ApplicationMailer
  def notify_about_release(user_id, raw_token)
    user = User.find(user_id)
    @token = raw_token
    @user = user
    subject = "The King's Awards for Enterprise: Welcome to our new application system"

    send_mail_if_not_bounces ENV.fetch("GOV_UK_NOTIFY_API_TEMPLATE_ID", nil), to: user.email, subject: subject_with_env_prefix(subject)
  end
end
