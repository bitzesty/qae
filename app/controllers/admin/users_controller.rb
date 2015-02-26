class Admin::UsersController < Admin::BaseController
  before_filter :find_resource, only: [:show, :edit, :update, :destroy]

  def index
    params[:search] ||= UserSearch::DEFAULT_SEARCH
    authorize User, :index?

    if search_query.present?
      scope = User.basic_search(search_query)
    else
      scope = User.all
    end

    @search = UserSearch.new(scope).search(params[:search])
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

  helper_method :search_query

  def search_query
    params[:query]
  end

  def find_resource
    @resource = User.find(params[:id])
  end

  def resource_params
    params.require(:user).permit(
      :title,
      :first_name,
      :last_name,
      :job_title,
      :phone_number,
      :email,
      :role,
      :company_name,
      :company_phone_number,
      :subscribed_to_emails,
      :qae_info_source,
      :qae_info_source_other,
      :current_password,
      :password,
      :password_confirmation
    )
  end
end
