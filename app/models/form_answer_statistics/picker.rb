class FormAnswerStatistics::Picker
  def inititialize
  end

  def registered_users
    out = {}
    out[:last_24h] = User.where(created_at: (Time.now - 24.hours)..Time.now).count
    out[:last_7_days] = User.where(created_at: (Time.now - 7.days)..Time.now).count
    out[:total_so_far] = User.count
    out
  end

  def applications_submitted
    out = {
      last_24h: "to clarify",
      last_7_days: "to clarify"
    }

    out[:total_so_far] = FormAnswer.submitted.count
    out
  end

  def applications_in_progress
    out = {
      last_24h: "to clarify",
      last_7_days: "to clarify"
    }
    out[:total_so_far] = FormAnswer.where(state: "in_progress1").count
    out
  end

  def applications_not_started
    out = {
      last_24h: "to clarify",
      last_7_days: "to clarify"
    }
    out[:total_so_far] = "to clarify"
    out
  end

  def applications_submitted
    out = {
      trend: "Not impl.",
      total_last_year: "Not impl."
    }
  end

  # 2nd table
  def applications_completion
    # TODO: scope with year
    out = {}
    klass::POSSIBLE_AWARDS.each do |aw|
      scope = klass.where(award_type: aw)
      out[aw] = collect_completion_ranges(scope)
    end

    out["total"] = collect_completion_ranges(klass.all)

    out
  end

  private

  def collect_completion_ranges(scope)
    out = []
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
