class Admin::AdminsController < Admin::UsersController
  def index
    params[:search] ||= AdminSearch::DEFAULT_SEARCH

    @search = AdminSearch.new(Admin.where(role: "admin")).search(params[:search])
    @resources = @search.results.page(params[:page])
  end

  def new
    @resource = Admin.new
  end

  def create
    @resource = Admin.new(resource_params)
    @resource.role = "admin"

    @resource.save
    respond_with :admin, @resource
  end

  private

  def find_resource
    @resource = Admin.where(role: "admin").find(params[:id])
  end

  def resource_params
    params.require(:admin).permit(:email, :password, :password_confirmation, :first_name, :last_name)
  end
end
