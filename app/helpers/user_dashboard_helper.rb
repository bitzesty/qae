module UserDashboardHelper
  def unsuccessful_collection(form_answers)
    unsuccessful = []
    now = DateTime.now

    not_shortlisted_deadline = Settings.not_shortlisted_deadline
    not_awarded_deadline = Settings.not_awarded_deadline
    if not_shortlisted_deadline.present? && not_shortlisted_deadline < now
      unsuccessful += form_answers.select { |fa| fa.state == "not_recommended" }
    end

    if not_awarded_deadline.present? && not_awarded_deadline < now
      unsuccessful += form_answers.select { |fa| fa.state == "not_awarded" }
    end

    unsuccessful
  end
end
