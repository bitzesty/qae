class Admin::AssessorsController < Admin::UsersController
  def index
    params[:search] ||= AssessorSearch::DEFAULT_SEARCH

    @search = AssessorSearch.new(Admin.where(role: %w[lead_assessor assessor])).
                             search(params[:search])
    @resources = @search.results.page(params[:page])
  end

  def new
    @resource = Admin.new
  end

  def create
    @resource = Admin.new(resource_params)

    @resource.save
    respond_with :admin, @resource, location: admin_assessor_path(@resource)
  end

  def update
    if resource_params[:password].present?
      @resource.update(resource_params)
    else
      @resource.update_without_password(resource_params)
    end

    respond_with :admin, @resource, location: admin_assessor_path(@resource)
  end

  def destroy
    @resource.destroy
    respond_with :admin, @resource, location: admin_assessors_path
  end

  private

  def find_resource
    @resource = Admin.where(role: %w[lead_assessor assessor]).find(params[:id])
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
