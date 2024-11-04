class Admins::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: :developer

  def dbt_staff_sso
    FindAndUpdateWithAuth.new(auth: request.env["omniauth.auth"], model: Admin).run.tap do |result|
      if result.success
        sign_in_and_redirect result.user, event: :authentication
        set_flash_message(:notice, :success, kind: "DBT Staff SSO")
      else
        set_flash_message(:notice, :error, kind: result.errors)
        redirect_to new_admin_session_url
      end
    end
  end

  def developer
    raise "developer strategy should only be used in development!" unless Rails.env.development?

    FindAndUpdateWithAuth.new(auth: request.env["omniauth.auth"], model: Admin).run.tap do |result|
      if result.success
        sign_in_and_redirect result.user, event: :authentication
        set_flash_message(:notice, :success, kind: "Developer SSO")
      else
        set_flash_message(:notice, :error, kind: result.errors)
        redirect_to new_admin_session_url
      end
    end
  end

  def failure
    redirect_to admin_root_path
  end
end
