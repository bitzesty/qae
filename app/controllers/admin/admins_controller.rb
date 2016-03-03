class Admin::AdminsController < Admin::UsersController
  def index
    params[:search] ||= AdminSearch::DEFAULT_SEARCH
    authorize Admin, :index?
    @search = AdminSearch.new(Admin.all).
                         search(params[:search])
    @resources = @search.results.page(params[:page])
  end

  def new
    @resource = Admin.new
    authorize @resource, :create?
  end

  def create
    @resource = Admin.new(resource_params)
    authorize @resource, :create?

    @resource.save
    location = @resource.persisted? ? admin_admins_path : nil
    respond_with :admin, @resource, location: location
  end

  def update
    authorize @resource, :update?

    if resource_params[:password].present?
      @resource.update(resource_params)
    else
      @resource.update_without_password(resource_params)
    end

    respond_with :admin, @resource, location: admin_admins_path
  end

  # TODO: remove it once you fix issue with assessor access
  def login_as_assessor
    authorize Admin, :index?
    assessor = Assessor.find_by_email(params[:email])
    sign_in(assessor, bypass: true)

    redirect_to assessor_root_path
  end

  private

  def find_resource
    @resource = Admin.find(params[:id])
  end

  def resource_params
    params.require(:admin).
      permit(:email,
             :password,
             :password_confirmation,
             :first_name,
             :last_name)
  end
end
