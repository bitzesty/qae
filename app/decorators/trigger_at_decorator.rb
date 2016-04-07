module TriggerAtDecorator
  PLACEHOLDER = "<strong>-- --- #{AwardYear.current.year}</strong> at --:--".html_safe
  DATE_PLACEHOLDER = "<strong>-- --- #{AwardYear.current.year}</strong>".html_safe

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

  def formatted_trigger_date(format=nil)
    return DATE_PLACEHOLDER unless object.trigger_at

    str_format = "#{object.trigger_at.day.ordinalize} %B"
    str_format = str_format + " %Y" if format.present? && format == "with_year"

    object.trigger_at.strftime(str_format)
  end
end
