class DashboardPolicy < ApplicationPolicy
  def index?
    true
  end

  def downloads?
    true
  end

  def totals_by_month?
    true
  end

  def totals_by_week?
    true
  end

  def totals_by_day?
    true
  end
end
