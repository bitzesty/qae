# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
  # The path used after confirmation.
  def after_confirmation_path_for(resource_name, resource)
    if resource.is_a?(User) && resource.encrypted_password.blank?
      sign_in(resource, scope: resource_name)
      password_settings_account_path
    else
      super(resource_name, resource)
    end
  end
end
