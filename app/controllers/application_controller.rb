require "app_responder"

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?

  self.responder = AppResponder
  respond_to :html

  def after_sign_in_path_for(resource)
    dashboard_path
  end

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
               :prefered_method_of_contact, :subscribed_to_emails)
    end
  end
end
