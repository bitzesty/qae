class Reports::Dashboard::UsersReport < Reports::Dashboard::Base
  def initialize(kind:)
    @kind = kind
  end

  def stats
    public_send("stats_#{kind}")
  end

  def scope(award_year)
    User.where("created_at >= ?", Date.new(award_year.year - 1, 1, 1))
  end

  def stats_by_month
    award_year_range.map do |award_year|
      users = scope(award_year)
      deadline = submission_deadline(award_year)
      deadline_month = deadline.try(:month)

      content = (4..deadline_month || 9).to_a.map do |month|
        date = if month == deadline_month
          deadline
        else
          Date.new(award_year.year - 1, month).end_of_month
        end

        generate_content(users, deadline_month ? date : nil)
      end

      Reports::Dashboard::Row.new(label(award_year), content)
    end
  end

  def stats_by_week
    award_year_range.map do |award_year|
      users = scope(award_year)
      deadline = submission_deadline(award_year)

      content = 6.downto(0).map do |weeks_diff|
        date = deadline.present? ? (deadline - weeks_diff.weeks).end_of_day : nil

        generate_content(users, date)
      end

      Reports::Dashboard::Row.new(label(award_year), content)
    end
  end

  def stats_by_day
    award_year_range.map do |award_year|
      users = scope(award_year)
      deadline = submission_deadline(award_year)

      content = 6.downto(0).map do |days_diff|
        date = deadline.present? ? (deadline - days_diff.days).end_of_day : nil

        generate_content(users, date)
      end

      Reports::Dashboard::Row.new(label(award_year), content)
    end
  end


  def generate_content(users, date)
    if date && Date.current >= date
      users.where("created_at < ?", date).count
    else
      "&nbsp;".html_safe
    end
  end
end
