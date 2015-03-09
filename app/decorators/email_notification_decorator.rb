class EmailNotificationDecorator < ApplicationDecorator
  include TriggerAtDecorator

  def header
    I18n.t("email_notification_headers.#{kind}")
  end

  def email_example
  end
end
