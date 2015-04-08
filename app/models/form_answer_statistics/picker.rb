class FormAnswerStatistics::Picker
  def registered_users
    out = {}
    out[:last_24h] = User.where(created_at: (Time.now - 24.hours)..Time.now).count
    out[:last_7_days] = User.where(created_at: (Time.now - 7.days)..Time.now).count
    out[:total_so_far] = User.count
    out
  end

  def applications_completions
    # TODO: SCOPE WITH YEAR
    out = {}
    klass::POSSIBLE_AWARDS.each do |aw|
      scope = klass.where(award_type: aw)
      out[aw] = collect_completion_ranges(scope)
    end
    out["total"] = collect_completion_ranges(klass.where.not(state: "not_eligible").where(submitted: false))
    out
  end

  def applications_submissions
    out = {}
    klass::POSSIBLE_AWARDS.each do |aw|
      scope = klass.where(award_type: aw)
      out[aw] = collect_submission_ranges(scope)
    end

    out["total"] = collect_submission_ranges(klass.all)
    out
  end

  private

  def submissions_query(scope, time_range)
    out = scope.joins(:form_answer_transitions)
    out = out.where("form_answer_transitions.to_state = ?", "submitted")
    out = out.where("form_answer_transitions.created_at > ?", time_range) if time_range
    out.uniq.count
  end

  def collect_submission_ranges(scope)
    temp = []
    temp << submissions_query(scope, DateTime.now - 1.day)
    temp << submissions_query(scope, DateTime.now - 7.days)
    temp << submissions_query(scope, nil)
    temp
  end

  def collect_completion_ranges(scope)
    out = []
    out << scope.where(state: "not_eligible").count
    scope = scope.where.not(state: "not_eligible").where(submitted: false)
    out << scope.where(fill_progress: 0).count
    range2 = scope.where("fill_progress > ? AND fill_progress < ?", 0, 0.25)
    out << range2.count
    range3 = scope.where("fill_progress >= ? AND fill_progress < ?", 0.25, 0.5)
    out << range3.count
    range4 = scope.where("fill_progress >= ? AND fill_progress < ?", 0.5, 0.75)
    out << range4.count
    range5 = scope.where("fill_progress >= ? AND fill_progress < ?", 0.75, 1)
    out << range5.count
    range6 = scope.where(fill_progress: 1)
    out << range6.count
    out << scope.count
    out
  end

  def klass
    FormAnswer
  end
end
