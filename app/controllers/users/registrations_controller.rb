class Users::RegistrationsController < Devise::RegistrationsController
  def new
    if session[:agreed_with_privacy_policy]
      super
    else
      render :privacy_policy_agreement
    end
  end

  def privacy_policy_agreement
    if session[:agreed_with_privacy_policy]
      redirect_to new_user_registration_path
    end
  end

  def update_privacy_policy_agreement
    if params[:agreed_with_privacy_policy] == 'true'
      session[:agreed_with_privacy_policy] = true
      flash.clear

      redirect_to new_user_registration_path
    else
      flash[:alert] = 'You should agree with the privacy policy first'
      render :privacy_policy_agreement
    end
  end
end
