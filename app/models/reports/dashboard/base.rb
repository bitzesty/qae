class Reports::Dashboard::Base
  attr_reader :kind

  def award_year_range
    AwardYear.where(year: AwardYear.current.year - 2..AwardYear.current.year).order("year DESC")
  end

  def label(award_year)
    "#{award_year.year - 1} - #{award_year.year} " + submission_deadline_label(award_year)
  end

  def submission_deadline_label(award_year)
    if deadline = submission_deadline(award_year)
      "(#{deadline.strftime("%m/%d/%Y")})"
    else
      ""
    end
  end

  def submission_deadline(award_year)
    award_year.settings.deadlines.submission_end.first.trigger_at
  end
end
