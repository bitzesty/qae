module TriggerAtDecorator
  def formatted_trigger_time(format = { bold: true })
    return placeholder unless object.trigger_at

    trigger_on = object.trigger_at.strftime(format[:date_format] || "%-d %b %Y")

    trigger_at = object.trigger_at.strftime(format[:time_format] || "%-l:%M%P")
    trigger_at = "midnight" if midnight?
    trigger_at = "midday" if midday?

    if format[:bold]
      h.tag.strong(trigger_on) + " at #{trigger_at}".html_safe
    else
      "#{trigger_on} at #{trigger_at}"
    end
  end

  def formatted_trigger_time_short
    return placeholder unless object.trigger_at

    object.trigger_at.strftime("%d/%m/%Y")
  end

  def formatted_trigger_date(format = nil)
    return date_placeholder unless object.trigger_at

    str_format = "#{object.trigger_at.day.ordinalize} %B"
    str_format += " %Y" if format.present? && format == "with_year"

    object.trigger_at.strftime(str_format)
  end

  def formatted_trigger_day
    return date_placeholder unless object.trigger_at

    object.trigger_at.strftime("%A")
  end

  private

  def placeholder
    "<strong>-- --- #{AwardYear.current.year}</strong> at --:--".html_safe
  end

  def date_placeholder
    "<strong>-- --- #{AwardYear.current.year}</strong>".html_safe
  end

  def midday?
    object.trigger_at == object.trigger_at.midday
  end

  def midnight?
    object.trigger_at == object.trigger_at.midnight
  end
end
