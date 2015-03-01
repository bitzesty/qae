class Assessor::DashboardController < Assessor::BaseController
  def index
    authorize :dashboard, :index?
  end
end
