module UserDashboardHelper
  def unsuccessful_collection(form_answers)
    states = {}
    now = DateTime.now

    not_shortlisted_deadline = Settings.not_shortlisted_deadline
    not_awarded_deadline = Settings.not_awarded_deadline
    if not_shortlisted_deadline.present? && not_shortlisted_deadline < now
      states["not_recommended"] = true
    end

    if not_awarded_deadline.present? && not_awarded_deadline < now
      states["not_awarded"] = true
    end

    form_answers.select { |fa| states[fa.state] }
  end
end
