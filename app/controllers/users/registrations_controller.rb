class Users::RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(resource)
    if resource.is_a?(User)
      eligibility_path
    else
      super
    end
  end

  def build_resource(hash=nil)
    super

    resource.role = 'account_admin' if action_name == 'create'
  end
end
