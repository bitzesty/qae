class Admin::UsersController < Admin::BaseController
  before_filter :find_resource, only: [:show, :edit, :update, :destroy]

  def index
    params[:search] ||= UserSearch::DEFAULT_SEARCH
    authorize User, :index?
    @search = UserSearch.new(User.all).search(params[:search])
    @resources = @search.results.page(params[:page])
  end

  def new
    @resource = User.new
    authorize @resource, :create?
  end

  def show
    authorize @resource, :show?
  end

  def edit
    authorize @resource, :update?
  end

  def create
    @resource = User.new(resource_params)
    @resource.agreed_with_privacy_policy = "1"
    authorize @resource, :create?

    @resource.save
    respond_with :admin, @resource
  end

  def update
    authorize @resource, :update?

    if resource_params[:password].present?
      @resource.update(resource_params)
    else
      @resource.update_without_password(resource_params)
    end

    respond_with :admin, @resource
  end

  def destroy
    authorize @resource, :destroy?

    @resource.destroy
    respond_with :admin, @resource
  end

  private

  def find_resource
    @resource = User.find(params[:id])
  end

  def resource_params
    params.require(:user).permit(:email, :role, :password, :password_confirmation)
  end
end
