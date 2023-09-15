class Admin::JudgesController < Admin::UsersController
  def index
    params[:search] ||= JudgeSearch::DEFAULT_SEARCH
    params[:search].permit!
    authorize :judge, :index?

    @search = JudgeSearch.new(Judge.active).
                             search(params[:search])
    @resources = @search.results.page(params[:page])
  end

  def new
    @resource = Judge.new
    authorize @resource, :create?
  end

  def create
    @resource = Judge.new(resource_params)
    authorize @resource, :create?

    @resource.save
    location = @resource.persisted? ? admin_judges_path : nil

    render_flash_message_for(@resource, message: @resource.errors.none? ? nil : @resource.errors.messages.values.flatten.uniq.join("<br />"))

    respond_with :admin, @resource, location: location
  end

  def update
    authorize @resource, :update?

    if resource_params[:password].present?
      @resource.update(resource_params)
    else
      @resource.update_without_password(resource_params)
    end

    render_flash_message_for(@resource, message: @resource.errors.none? ? nil : @resource.errors.messages.values.flatten.uniq.join("<br />"))

    respond_with :admin, @resource, location: admin_judges_path
  end

  def destroy
    authorize @resource, :destroy?
    @resource.soft_delete!

    render_flash_message_for(@resource, message: @resource.errors.none? ? nil : @resource.errors.messages.values.flatten.uniq.join("<br />"))

    respond_with :admin, @resource, location: admin_judges_path
  end

  private

  def find_resource
    @resource = Judge.active.find(params[:id])
  end

  def resource_params
    params.require(:judge).
      permit(:email,
             :password,
             :password_confirmation,
             :first_name,
             :last_name,
             :trade_role,
             :innovation_role,
             :development_role,
             :mobility_role,
             :promotion_role)
  end
end
