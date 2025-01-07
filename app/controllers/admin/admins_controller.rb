class Admin::AdminsController < Admin::BaseController
  before_action :find_resource, except: [:index, :login_as_assessor, :login_as_user]

  def index
    params[:search] ||= AdminSearch::DEFAULT_SEARCH
    params[:search].permit!
    authorize Admin, :index?
    @search = AdminSearch.new(Admin.all)
                         .search(params[:search])
    @resources = @search.results.page(params[:page])
    render template: "admin/users/index"
  end

  # NOTE: debug abilities for Admin - BEGIN
  def login_as_assessor
    authorize Admin, :index?
    assessor = Assessor.find_by(email: params[:email])
    sign_in(assessor, scope: :assessor, skip_session_limitable: true)

    redirect_to assessor_root_path
  end

  def login_as_user
    authorize Admin, :index?
    user = User.find_by(email: params[:email])
    sign_in(user, scope: :user, skip_session_limitable: true)

    redirect_to dashboard_url
  end
  # NOTE: debug abilities for Admin - END

  private

  def find_resource
    @resource = Admin.find(params[:id])
  end
end
