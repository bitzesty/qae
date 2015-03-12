require "app_responder"

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?

  self.responder = AppResponder
  respond_to :html

  decent_configuration do
    strategy DecentExposure::StrongParametersStrategy
  end

  def after_sign_in_path_for(resource)
    if resource.is_a?(User)
      dashboard_path
    else
      super
    end
  end

  def admin_in_read_only_mode?
    @admin_in_read_only_mode ||= admin_signed_in? &&
                                 session["warden.user.user.key"] &&
                                 session[:admin_in_read_only_mode]
  end
  helper_method :admin_in_read_only_mode?

  def restrict_access_if_admin_in_read_only_mode!
    if admin_in_read_only_mode?
      redirect_to root_url, alert: "You have no permissions!"
      return
    end
  end

  def current_account
    current_user && current_user.account
  end
  helper_method :current_account

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :password_confirmation, :agreed_with_privacy_policy) }
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:email, :current_password, :password, :password_confirmation,
               :completed_registration,
               :title, :first_name, :last_name,
               :job_title, :phone_number,
               :company_name, :company_address_first, :company_address_second,
               :company_city, :company_country, :company_postcode,
               :company_phone_number,
               :prefered_method_of_contact, :subscribed_to_emails, :agree_being_contacted_by_department_of_business)
    end
  end

  def check_account_completion
    if !current_user.completed_registration?
      redirect_to correspondent_details_account_path
      return
    end
  end

  def require_to_be_account_admin!
    unless current_user.account_admin?
      redirect_to root_path,
                  notice: "Access denied!"
    end
  end
end
