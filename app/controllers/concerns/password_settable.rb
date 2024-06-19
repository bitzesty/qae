module PasswordSettable
  def after_confirmation_path_for(resource_name, resource)
    if resource.encrypted_password.blank?
      token, encoded_token = Devise.token_generator.generate(resource.class, :reset_password_token)
      resource.update(reset_password_token: encoded_token,
        reset_password_sent_at: Time.current)

      password_reset_path(token)
    else
      super(resource_name, resource)
    end
  end
end
