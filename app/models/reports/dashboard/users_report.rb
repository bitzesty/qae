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

      content = (4..deadline.month).to_a.map do |month|
        date = if month == deadline.month
          deadline
        else
          Date.new(award_year.year - 1, month).end_of_month
        end

        generate_content(users, date)
      end

      Reports::Dashboard::Row.new(label(award_year), content)
    end
  end

  def stats_by_week
    award_year_range.map do |award_year|
      users = scope(award_year)
      deadline = submission_deadline(award_year)

      content = 6.downto(0).map do |weeks_diff|
        date = deadline - weeks_diff.weeks

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
        date = deadline - days_diff.days

        generate_content(users, date)
      end

      Reports::Dashboard::Row.new(label(award_year), content)
    end
  end


  def generate_content(users, date)
    if Date.current >= date
      users.where("created_at < ?", date).count
    else
      "&nbsp;".html_safe
    end
  end
end
