class Reports::Dashboard::ApplicationsReport < Reports::Dashboard::Base
  attr_reader :award_type

  def initialize(kind:, award_type: nil)
    @kind = kind
    @award_type = award_type
  end

  def stats
    public_send("stats_#{kind}")
  end

  def scope(award_year)
    if award_type.present?
      AwardYear.where(year: award_year).first.form_answers.for_award_type(award_type)
    else
      AwardYear.where(year: award_year).first.form_answers
    end
  end

  def stats_by_month
    award_year_range.map do |award_year|
      form_answers = scope(award_year.year)
      deadline = submission_deadline(award_year)
      deadline_month = deadline.try(:month)
      content = (4..deadline_month || 9).to_a.map do |month|
        date = if month == deadline_month
          deadline
        else
          Date.new(award_year.year - 1, month).end_of_month
        end

        generate_content(form_answers, deadline_month ? date : nil)
      end.flatten

      Reports::Dashboard::Row.new(label(award_year), content)
    end
  end

  def stats_by_week
    award_year_range.map do |award_year|
      form_answers = scope(award_year.year)
      deadline = submission_deadline(award_year)

      content = 6.downto(0).map do |weeks_diff|
        date = deadline.present? ? (deadline - weeks_diff.weeks).end_of_day : nil

        generate_content(form_answers, date)
      end.flatten

      Reports::Dashboard::Row.new(label(award_year), content)
    end
  end

  def stats_by_day
    award_year_range.map do |award_year|
      form_answers = scope(award_year.year)
      deadline = submission_deadline(award_year)

      content = 6.downto(0).map do |days_diff|
        date = deadline.present? ? (deadline - days_diff.days).end_of_day : nil

        generate_content(form_answers, date)
      end.flatten

      Reports::Dashboard::Row.new(label(award_year), content)
    end
  end

  def generate_content(form_answers, date)
    created_count = form_answers.where("created_at < ?", date).count
    submitted_count = form_answers.where("submitted_at < ?", date).count

    if date && Date.current > date
      [
        created_count - submitted_count, # in progress
        submitted_count,
      ]
    else
      ["&nbsp;".html_safe, "&nbsp;".html_safe]
    end
  end

  def as_csv
    CSV.generate do |csv|
      headers = ["Year"]
      case kind
      when "by_month"
        columns = ["By end of April", "By end of May", "By end of June", "By end of July", "By end of August", "Totals on deadline"]
      when "by_week"
        columns = ["6 weeks before deadline", "5 weeks before deadline", "4 weeks before deadline", "3 weeks before deadline", "2 weeks before deadline", "1 week before deadline", "Totals on deadline"]
      when "by_day"
        columns = ["6 days before deadline", "5 days before deadline", "4 days before deadline", "3 days before deadline", "2 days before deadline", "1 day before deadline", "Totals on deadline"]
      end
      csv << (headers + columns.map{ |c| [c] << nil }).flatten
      subheaders = [""]
      columns.each{ subheaders << ["In progress", "Submitted"] }
      csv << subheaders.flatten

      stats.each do |row|
        content = []
        content << row.label
        row.content.each{ |c| content << (c == "&nbsp;" ? nil : c) }
        csv << content
      end
    end
  end

  def csv_filename
    "#{award_type || "all"}_applications_report_#{kind}.csv"
  end
end
