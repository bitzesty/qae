class Users::CustomMailer < ApplicationMailer
  def notify(user_id, user_class, body, subject)
    return unless %w[Admin User Assessor].include?(user_class)

    @user = user_class.constantize.find(user_id).decorate
    @body = body

    send_mail_if_not_bounces ENV.fetch("GOV_UK_NOTIFY_API_TEMPLATE_ID", nil), to: @user.email, subject: subject_with_env_prefix(subject)
  end
end
