# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
  include Users::ReasonablyParanoidable
  include PasswordSettable

  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    yield resource if block_given?

    if resource.errors.empty?
      set_flash_message!(:success, :confirmed)
      respond_with_navigational(resource){ redirect_to after_confirmation_path_for(resource_name, resource) }
    else
      respond_with_navigational(resource.errors, status: :unprocessable_entity){ render :new }
    end
  end

  private

  def password_reset_path(token)
    edit_user_password_path(reset_password_token: token, locals: { password_not_set: true })
  end
end
