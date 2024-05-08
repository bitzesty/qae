require "app_responder"
include AuditHelper

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception, prepend: true

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_context_tags
  before_action :set_paper_trail_whodunnit
  before_action :disable_browser_caching!

  self.responder = AppResponder
  respond_to :html

  def after_sign_in_path_for(resource)
    if resource.is_a?(User)
      custom_redirect_url = session[:custom_redirect]

      if custom_redirect_url.present?
        session[:custom_redirect] = nil
        custom_redirect_url
      else
        dashboard_path
      end
    else
      super
    end
  end

  def admin_in_read_only_mode?
    @admin_in_read_only_mode ||= (admin_signed_in? || assessor_signed_in?) &&
                                 session["warden.user.user.key"] &&
                                 session[:admin_in_read_only_mode]
  end
  helper_method :admin_in_read_only_mode?

  def restrict_access_if_admin_in_read_only_mode!
    if admin_in_read_only_mode?
      if request.referer
        flash[:alert] = "You have no permissions!"
        redirect_back(fallback_location: root_path)
      else
        render text: "You have no permissions!"
      end
      return
    end
  end

  def allow_assessor_access!(fa)
    if admin_in_read_only_mode?
      if assessor_signed_in? && !admin_signed_in?
        if fa.present?
          if current_assessor.lead_or_assigned?(fa)
            return true
          end
        end
        if request.referer
          flash[:alert] = "You have no permissions!"
          redirect_back(fallback_location: root_path)
        else
          render text: "You have no permissions!"
        end
        return false
      end
    end
  end

  def current_account
    current_user && current_user.account
  end
  helper_method :current_account

  def should_enable_js?
    browser = Browser.new(request.env["HTTP_USER_AGENT"], accept_language: "en-gb")

    !browser.ie? || browser.ie?([">8"])
  end
  helper_method :should_enable_js?

  %w(innovation trade mobility development).each do |award|
    define_method "#{award}_submission_started?" do
      public_send("#{award}_submission_started_deadline").passed?
    end
    helper_method "#{award}_submission_started?"

    define_method "#{award}_submission_started_deadline" do
      Settings.public_send("current_#{award}_submission_start_deadline")
    end
    helper_method "#{award}_submission_started_deadline"
  end

  protected

  def settings
    Rails.cache.fetch("current_settings", expires_in: 1.minute) do
      AwardYear.current.settings
    end
  end

  def submission_started?
    submission_started_deadlines.any?(&:passed?)
  end
  helper_method :submission_started?

  def submission_started_deadlines
    Settings.current_submission_start_deadlines
  end

  def submission_ended?
    submission_deadline.passed?
  end
  helper_method :submission_ended?

  def current_form_submission_ended?
    return false if current_admin.present? && current_admin.superadmin?
    Rails.cache.fetch("form_submission_ended_#{@form_answer.id}", expires_in: 1.minute) do
      @form_answer.submission_ended?
    end
  end
  helper_method :current_form_submission_ended?

  def submission_started_deadline
    Settings.current_submission_start_deadline
  end
  helper_method :submission_started_deadline

  def submission_deadline
    Settings.current_submission_deadline
  end
  helper_method :submission_deadline

  def log_action(action_type)
    AuditLog.create!(subject: current_subject, action_type: action_type)
  end

  def log_event
    AuditLog.create!(
      subject: current_subject,
      auditable: form_answer,
      action_type: action_type
      )
  end

  def current_subject
    current_user || dummy_user
  end

  #
  # Disabling browser caching in order
  # to protect sensitive data
  #
  def disable_browser_caching!
    response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "0"
  end

  def set_context_tags
    context = { current_user: current_user.try(:id) }
    Appsignal.tag_request(context)
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :sign_up,
      keys: [
        :email,
        :password,
        :password_confirmation,
        :agreed_with_privacy_policy
      ]
    )
    devise_parameter_sanitizer.permit(
      :account_update,
      keys: [
        :email,
        :current_password,
        :password,
        :password_confirmation,
        :completed_registration,
        :title,
        :first_name,
        :last_name,
        :job_title,
        :phone_number,
        :company_name,
        :company_address_first,
        :company_address_second,
        :company_city,
        :company_country,
        :company_postcode,
        :company_phone_number,
        :prefered_method_of_contact,
        :subscribed_to_emails,
        :agree_being_contacted_by_department_of_business
      ]
    )
  end

  def check_account_completion
    if !current_user.completed_registration?
      redirect_to correspondent_details_account_path
      return
    end
  end

  # We need to know whether the user is happy for their details to be shared with Lord-Lieutenants
  def check_additional_contact_preferences
    if current_user.agree_sharing_of_details_with_lieutenancies.nil?
      redirect_to additional_contact_preferences_account_path
    end
  end

  # We only allow to use the system if an account has 1 or more collaborator
  # We also ask users to keep information up to date
  def check_number_of_collaborators
    if current_user.account_admin? && (current_account.has_no_collaborators? || !current_account.collaborators_checked?)
      session[:redirected_to_collaborators_page] = true
      redirect_to account_collaborators_path
    end
  end

  def require_to_be_account_admin!
    unless current_user.account_admin?
      redirect_to dashboard_path,
        notice: "Access denied!"
    end
  end

  def load_award_year_and_settings
    if params[:year] && AwardYear::AVAILABLE_YEARS.include?(params[:year].to_i)
      @award_year = AwardYear.for_year(params[:year].to_i).first_or_create
    else
      @award_year = AwardYear.current
    end

    @settings = @award_year.settings
    @deadlines = @settings.deadlines.to_a
  end

  def user_for_paper_trail
    if current_admin.present? && current_admin.superadmin?
      "ADMIN:#{current_admin.id}"
    elsif current_user.present?
      "USER:#{current_user.id}"
    end
  end

  #
  # Validate applications number per account - BEGIN
  # used in multiple controllers
  #

  def check_trade_count_limit
    check_applications_limit(:trade)
  end

  def check_development_count_limit
    check_applications_limit(:development)
  end

  def check_applications_limit(type_of_award)
    if current_account.has_award_in_this_year?(type_of_award)
      redirect_to dashboard_url, flash: {
        alert: "You can not submit more than one #{FormAnswer::AWARD_TYPE_FULL_NAMES[type_of_award.to_s]} form per year!",
      }
    end
  end

  #
  # Validate applications number per account - END
  # used in multiple controllers
  #
end
