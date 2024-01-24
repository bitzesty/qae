class Admins::ConfirmationsController < Devise::ConfirmationsController
  include PasswordSettable

  private

  def password_reset_path(token)
    edit_admin_password_path(reset_password_token: token, locals: { password_not_set: true })
  end
end
