module DeadlineHelper
  def update_current_submission_deadline
    award_year_switch = Settings.current_award_year_switch_date_or_default_trigger_at.to_date
    yesterday = DateTime.now - 1.day

    if yesterday.before?(award_year_switch)
      Settings.current_submission_deadline.update(trigger_at: award_year_switch + 1.day)
    else
      Settings.current_submission_deadline.update(trigger_at: yesterday)
    end
  end
end
