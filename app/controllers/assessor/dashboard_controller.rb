class Assessor::DashboardController < Assessor::BaseController
  def index
    authorize :dashboard, :index?
  end

  def suspended
    authorize :dashboard, :index?

    if current_assessor.suspended?
      render :suspended, layout: "application_suspended"
    else
      redirect_to assessor_root_path
    end
  end
end
