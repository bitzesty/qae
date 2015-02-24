class Admin::DashboardController < Admin::BaseController
  def index
    authorize :dashboard, :index?
  end
end
