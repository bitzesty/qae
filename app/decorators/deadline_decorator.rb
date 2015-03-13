class DeadlineDecorator < ApplicationDecorator
  include TriggerAtDecorator

  def message
    I18n.t("deadline_messages.#{kind}")
  end
end
