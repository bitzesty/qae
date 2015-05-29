module UserDashboardHelper
  def unsuccessful_collection(form_answers)
    states = {}
    now = DateTime.now

    after_not_shortlisted_deadline = Settings.not_shortlisted_deadline.try(:<, now)
    after_not_awarded_deadline = Settings.not_awarded_deadline.try(:<, now)

    states["not_recommended"] = after_not_shortlisted_deadline
    states["not_awarded"] = after_not_awarded_deadline

    form_answers.select { |fa| states[fa.state] }
  end
end
