class Admin::DashboardController < Admin::BaseController
  def index
    authorize :dashboard, :index?
    @statistics = FormAnswerStatistics::Picker.new(@award_year)
  end

  def totals_by_month
    authorize :dashboard, :totals_by_month?
  end
end
