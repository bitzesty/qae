module MailerHelper
  def formatted_deadline_time(deadline)
    # govuk suggested format is 12-hour clock with meridian indicator
    time = deadline.trigger_at.try :strftime, "%-I:%M %P"
    if time == "12:00 pm"
      "noon"
    elsif time == "12:00 am"
      "midnight"
    else
      time
    end
  end
end
