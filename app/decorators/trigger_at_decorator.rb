module TriggerAtDecorator
  def formatted_trigger_time(format = { bold: true })
    return placeholder unless object.trigger_at

    trigger_on = object.trigger_at.strftime(format[:date_format] || "%-d %b %Y")

    trigger_at = object.trigger_at.strftime(format[:time_format] || "%-l:%M%P")
    trigger_at = "midnight" if midnight?
    trigger_at = "midday" if midday?

    if format[:bold]
      h.capture do
        h.concat(h.tag.strong(trigger_on))
        h.concat(" at ")
        h.concat(trigger_at)
      end
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
    h.capture do
      h.concat(h.tag.strong("-- --- #{AwardYear.current.year}"))
      h.concat(" at --:--")
    end
  end

  def date_placeholder
    h.tag.strong("-- --- #{AwardYear.current.year}")
  end

  def midday?
    object.trigger_at == object.trigger_at.midday
  end

  def midnight?
    object.trigger_at == object.trigger_at.midnight
  end
end
