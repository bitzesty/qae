class Admin::AssessorsController < Admin::UsersController
  def index
    params[:search] ||= AssessorSearch::DEFAULT_SEARCH
    params[:search].permit!
    authorize :assessor, :index?

    @search = AssessorSearch.new(Assessor.all).
                             search(params[:search])
    @resources = @search.results.page(params[:page])
  end

  def new
    @resource = Assessor.new
    authorize @resource, :create?
  end

  def create
    @resource = Assessor.new(resource_params)
    authorize @resource, :create?

    @resource.save
    location = @resource.persisted? ? admin_assessors_path : nil

    render_flash_message_for(@resource, message: @resource.errors.none? ? nil : @resource.errors.messages.values.flatten.join("<br />"))

    respond_with :admin, @resource, location: location
  end

  def update
    authorize @resource, :update?

    if resource_params[:password].present?
      @resource.update(resource_params)
    else
      @resource.update_without_password(resource_params)
    end

    render_flash_message_for(@resource, message: @resource.errors.none? ? nil : @resource.errors.messages.values.flatten.join("<br />"))

    respond_with :admin, @resource, location: admin_assessors_path
  end

  def destroy
    authorize @resource, :destroy?
    @resource.soft_delete!

    render_flash_message_for(@resource, message: @resource.errors.none? ? nil : @resource.errors.messages.values.flatten.join("<br />"))

    respond_with :admin, @resource, location: admin_assessors_path
  end

  private

  def find_resource
    @resource = Assessor.find(params[:id])
  end

  def resource_params
    params.require(:assessor).
      permit(:email,
             :password,
             :password_confirmation,
             :company,
             :first_name,
             :last_name,
             :telephone_number,
             :trade_role,
             :innovation_role,
             :development_role,
             :mobility_role,
             :promotion_role)
  end
end
