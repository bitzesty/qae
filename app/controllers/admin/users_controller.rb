class Admin::UsersController < Admin::BaseController
  before_action :find_resource, except: [:index, :new, :create]

  def index
    params[:search] ||= UserSearch::DEFAULT_SEARCH
    params[:search].permit!

    authorize User, :index?

    @search = UserSearch.new(User.all).search(params[:search])
    @resources = @search.results.page(params[:page])
  end

  def new
    @resource = User.new
    authorize @resource, :create?
  end

  def edit
    authorize @resource, :update?
  end

  def create
    @resource = User.new(resource_params)
    @resource.agreed_with_privacy_policy = "1"
    authorize @resource, :create?

    @resource.save
    location = @resource.persisted? ? admin_users_path : nil

    render_flash_message_for(@resource, message: @resource.errors.none? ? nil : @resource.errors.messages.values.uniq.flatten.join("<br />"))

    respond_with :admin, @resource, location: location
  end

  def update
    authorize @resource, :update?

    if resource_params[:password].present?
      @resource.update_with_password(resource_params)
    else
      @resource.update_without_password(resource_params)
    end

    render_flash_message_for(@resource, message: @resource.errors.none? ? nil : @resource.errors.messages.values.uniq.flatten.join("<br />"))

    respond_with :admin, @resource, location: admin_users_path
  end

  def resend_confirmation_email
    authorize @resource, :update?

    @resource.send_confirmation_instructions
    flash[:notice] = "Confirmation instructions were successfully sent to #{@resource.decorate.full_name} (#{@resource.email})"
    respond_with :admin, @resource,
                 location: admin_users_path
  end

  def unlock
    authorize @resource, :update?

    @resource.unlock_access!
    flash[:notice] = "User #{@resource.decorate.full_name} (#{@resource.email}) successfully unlocked!"
    respond_with :admin, @resource,
                 location: edit_admin_user_path(@resource)
  end

  def scan_via_debounce_api
    authorize @resource, :update?

    ::ApplicantEmailDebounceApiCheckWorker.perform_async(@resource.id)

    flash[:notice] = "Scanning of email for this user successfully scheduled! Please refresh page in a minute!"
    respond_with :admin, @resource,
                 location: edit_admin_user_path(@resource)
  end

  private

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
      :agree_being_contacted_by_department_of_business,
      :qae_info_source,
      :qae_info_source_other,
      :notification_when_innovation_award_open,
      :notification_when_trade_award_open,
      :notification_when_development_award_open,
      :notification_when_mobility_award_open,
      :notification_when_submission_deadline_is_coming,
      :current_password,
      :password,
      :password_confirmation,
      :agree_sharing_of_details_with_lieutenancies
    )
  end
end
