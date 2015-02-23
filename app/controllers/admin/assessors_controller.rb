class Admin::AssessorsController < Admin::UsersController
  def index
    params[:search] ||= AssessorSearch::DEFAULT_SEARCH
    authorize :assessor, :index?

    @search = AssessorSearch.new(Admin.assessors).
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
    location = @resource.persisted? ? admin_assessor_path(@resource) : nil
    respond_with :admin, @resource, location: location
  end

  def update
    authorize @resource, :update?

    if resource_params[:password].present?
      @resource.update(resource_params)
    else
      @resource.update_without_password(resource_params)
    end

    respond_with :admin, @resource, location: admin_assessor_path(@resource)
  end

  def destroy
    authorize @resource, :destroy?
    @resource.destroy
    respond_with :admin, @resource, location: admin_assessors_path
  end

  private

  def find_resource
    @resource = Admin.assessors.find(params[:id])
  end

  def resource_params
    params.require(:assessor).
      permit(:email,
             :password,
             :password_confirmation,
             :first_name,
             :last_name,
             :role)
  end
end
