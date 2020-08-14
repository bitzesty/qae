class Admin::DashboardController < Admin::BaseController
  def index
    authorize :dashboard, :index?
    @statistics = FormAnswerStatistics::Picker.new(@award_year)
  end

  def downloads
    authorize :dashboard, :index?
  end

  def totals_by_month
    authorize :dashboard, :totals_by_month?
  end

  def totals_by_week
    authorize :dashboard, :totals_by_week?
  end

  def totals_by_day
    authorize :dashboard, :totals_by_day?
  end
end
