module TriggerAtDecorator
  PLACEHOLDER = "<strong>-- --- 2015</strong> at --:--".html_safe

  def formatted_trigger_time
    return PLACEHOLDER unless object.trigger_at

    trigger_on = object.trigger_at.strftime("%-d %b %Y")
    trigger_at = object.trigger_at.strftime("%k:%M")

    h.content_tag(:strong, trigger_on) + " at #{trigger_at}".html_safe
  end

  def formatted_trigger_time_short
    return PLACEHOLDER unless object.trigger_at

    object.trigger_at.strftime("%d/%m/%Y")
  end
end
