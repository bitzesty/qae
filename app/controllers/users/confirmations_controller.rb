# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
  # The path used after confirmation.
  def after_confirmation_path_for(resource_name, resource)
    if resource.is_a?(User) && resource.encrypted_password.blank?
      token, encoded_token = Devise.token_generator.generate(resource.class, :reset_password_token)
      resource.update(reset_password_token: encoded_token,
                      reset_password_sent_at: Time.current)

      edit_user_password_path(reset_password_token: token, locals: { password_not_set: true })
    else
      super(resource_name, resource)
    end
  end
end
