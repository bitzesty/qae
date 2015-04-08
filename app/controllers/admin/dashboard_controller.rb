class Admin::DashboardController < Admin::BaseController
  def index
    authorize :dashboard, :index?
    @statistics = FormAnswerStatistics::Picker.new
  end
end
