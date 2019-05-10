class Users::ApologyMailer < ApplicationMailer
  def notify(user_id)
    @user = User.find(user_id)
    @subject = "Queen's Awards for Enterprise: Multiple reminders sent by mistake"

    send_mail_if_not_bounces ENV['GOV_UK_NOTIFY_API_TEMPLATE_ID'], to: @user.email, subject: @subject
  end
end
