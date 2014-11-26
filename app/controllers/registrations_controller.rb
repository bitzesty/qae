class RegistrationsController < Devise::RegistrationsController
  def after_sign_up_path_for(resource)
    if resource.is_a?(User)
      eligibility_1_path
    end
  end
end
