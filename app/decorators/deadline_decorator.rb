class DeadlineDecorator < ApplicationDecorator
  include TriggerAtDecorator

  def message
    I18n.t("deadline_messages.#{kind}")
  end

  def help_message
    I18n.t("deadline_help_messages.#{kind}", default: "")
  end
end
