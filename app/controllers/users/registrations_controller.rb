class Users::RegistrationsController < Devise::RegistrationsController
  before_action :restrict_access_if_admin_in_read_only_mode!, only: [
    :update, :destroy
  ]

  protected

  def after_sign_up_path_for(resource)
    if resource.is_a?(User)
      account_path
    else
      super
    end
  end

  def after_inactive_sign_up_path_for(resource)
    if resource.is_a?(User)
      sign_up_complete_path
    else
      super
    end
  end

  def build_resource(hash = nil)
    super

    resource.role = "account_admin" if action_name == "create"
  end
end
