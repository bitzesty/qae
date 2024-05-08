class FormAnswerStatistics::Picker
  attr_reader :year

  def initialize(year)
    @year = year
  end

  def applications_table
    out = {}
    registered_users = []
    c = count_with_year(User.where(created_at: (Time.now - 24.hours)..Time.now))
    registered_users << c

    c = count_with_year(User.where(created_at: (Time.now - 7.days)..Time.now))
    registered_users << c

    registered_users << User.where(created_at: year.user_creation_range).count
    out[:registered_users] = { name: "Registered users", counters: registered_users }

    n_eligible = []
    n_eligible << count_with_year(not_eligible(DateTime.now - 1.day).count)
    n_eligible << count_with_year(not_eligible(DateTime.now - 7.days).count)
    n_eligible << fa_year_scope.where(state: "not_eligible").count
    out[:applications_not_eligible] = { name: "Applications not eligible", counters: n_eligible }

    eligibility_in_progress = []
    eligibility_in_progress << count_with_year(eligibility_in_progress(DateTime.now - 1.day).count)
    eligibility_in_progress << count_with_year(eligibility_in_progress(DateTime.now - 7.days).count)
    eligibility_in_progress << fa_year_scope.where(state: "eligibility_in_progress").count
    out[:eligibility_in_progress] = { name: "Applications with eligibility in progress", counters: eligibility_in_progress}

    in_progress = []
    in_progress << count_with_year(application_in_progress(Time.now - 1.days).count)
    in_progress << count_with_year(application_in_progress(Time.now - 7.days).count)
    in_progress << fa_year_scope.where(state: "application_in_progress").count
    out[:applications_in_progress] = { name: "Applications in progress", counters: in_progress }

    submitted = collect_submission_ranges(fa_year_scope.where.not(award_type: "promotion"))
    out[:applications_submitted] = {
      name: "Applications submitted",
      counters: submitted,
    }
    out
  end

  def applications_completions
    out = {}
    out["total"] = [0,0,0,0,0,0,0,0]
    klass::POSSIBLE_AWARDS.each do |aw|
      scope = fa_year_scope.where(award_type: aw).where(state: %w(application_in_progress eligibility_in_progress not_eligible))

      out[aw] = collect_completion_ranges(scope)
      unless aw == "promotion"
        out[aw].each_with_index do |val, index|
          out["total"][index] += val
        end
      end
    end
    out
  end

  def applications_submissions
    out = {}
    klass::POSSIBLE_AWARDS.each do |aw|
      scope = fa_year_scope.where(award_type: aw)
      out[aw] = collect_submission_ranges(scope)
    end

    out["total"] = collect_submission_ranges(fa_year_scope.where.not(award_type: "promotion"))
    out
  end

  private

  def fa_year_scope(scope = nil)
    scope ||= klass
    scope.where(award_year_id: year.id)
  end

  def count_with_year(scope)
    if current_awarding_year?
      scope.count
    else
      "-"
    end
  end

  def current_awarding_year?
    year.year == AwardYear.current.year
  end

  def application_in_progress(time_range)
    # application_in_progress it's initial state so need to check created_at as no
    # transitions records yet
    fa_year_scope.joins("LEFT OUTER JOIN form_answer_transitions on form_answers.id = form_answer_transitions.form_answer_id")
      .where(state: "application_in_progress")
      .where("(form_answer_transitions.to_state = ? AND
        form_answer_transitions.created_at > ?) OR (form_answers.created_at > ?)",
        "application_in_progress", time_range, time_range)
      .group("form_answers.id")
  end

  def eligibility_in_progress(time_range)
    fa_year_scope.joins(:form_answer_transitions)
      .where(state: "eligibility_in_progress")
      .where("form_answer_transitions.to_state = ? AND
        form_answer_transitions.created_at > ?", "eligibility_in_progress", time_range)
      .group("form_answers.id")
  end

  def not_eligible(time_range)
    fa_year_scope.joins(:form_answer_transitions)
      .where(state: "not_eligible")
      .where("form_answer_transitions.to_state = ? AND
        form_answer_transitions.created_at > ?", "not_eligible", time_range)
      .group("form_answers.id")
  end

  def submissions_query(scope, time_range)
    out = scope.joins(:form_answer_transitions)
    out = out.at_post_submission_stage
    out = out.where("form_answer_transitions.to_state = ?", "submitted")
    out = out.where("form_answer_transitions.created_at > ?", time_range) if time_range
    out.group("form_answers.id")
  end

  def collect_submission_ranges(scope)
    temp = []
    temp << count_with_year(submissions_query(scope, DateTime.now - 1.day).count)
    temp << count_with_year(submissions_query(scope, DateTime.now - 7.days).count)
    temp << submissions_query(fa_year_scope(scope), nil).count.count
    # .count.count above is not mistake - we use group("form_answers.id")

    temp
  end

  def collect_completion_ranges(scope)
    out = []
    not_e = scope.where(state: "not_eligible").count
    out << not_e
    eligibility_in_progress = scope.where(state: "eligibility_in_progress").count
    out << eligibility_in_progress
    applications_in_progress = scope.where(state: "application_in_progress")
    out << applications_in_progress.where(fill_progress: 0).count
    range2 = applications_in_progress.where("fill_progress > ? AND fill_progress < ?", 0, 0.25)
    out << range2.count
    range3 = applications_in_progress.where("fill_progress >= ? AND fill_progress < ?", 0.25, 0.5)
    out << range3.count
    range4 = applications_in_progress.where("fill_progress >= ? AND fill_progress < ?", 0.5, 0.75)
    out << range4.count
    range5 = applications_in_progress.where("fill_progress >= ? AND fill_progress <= ?", 0.75, 1)
    out << range5.count
    total_in_progress = scope.in_progress.count
    out << total_in_progress
    out
  end

  def klass
    FormAnswer
  end
end
