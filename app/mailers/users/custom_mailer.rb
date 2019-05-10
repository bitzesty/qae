require "rails_autolink"

class Users::CustomMailer < ApplicationMailer
  include ActionView::Helpers::TextHelper

  def notify(user_id, user_class, body, subject)
    if %w(Admin User Assessor).include?(user_class)
      @user = user_class.constantize.find(user_id).decorate
      @body = auto_link(simple_format(body))

      send_mail_if_not_bounces ENV['GOV_UK_NOTIFY_API_TEMPLATE_ID'], to: @user.email, subject: subject
    end
  end
end
