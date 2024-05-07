class AccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :restrict_access_if_admin_in_read_only_mode!

  def additional_contact_preferences
  end

  def correspondent_details
    @active_step = 1
  end

  def company_details
    @account_owner = current_user.account.owner
    @active_step = 3
  end

  def contact_settings
    @active_step = 2
  end

  def password_settings
    @active_step = 5
  end

  def useful_information
  end

  def update_correspondent_details
    current_user.set_step(1)
    if current_user.update(correspondent_details_params)
      redirect_to contact_settings_account_path
    else
      @active_step = 1
      render :correspondent_details
    end
  end

  def update_company_details
    current_user.set_step(3)
    if current_user.update(company_details_params)
      redirect_to account_collaborators_path
    else
      @active_step = 3
      render :company_details
    end
  end

  def update_contact_settings
    current_user.set_step(2)
    if current_user.update(contact_settings_params)

      if current_user.role.regular?
        current_user.update_attribute(:completed_registration, true)
        flash.notice = 'Your account details were successfully saved'
        redirect_to dashboard_path
      else
        redirect_to company_details_account_path
      end
    else
      @active_step = 3
      render :contact_settings
    end
  end

  def update_additional_contact_preferences
    if params[:user][:agree_sharing_of_details_with_lieutenancies].blank?
      current_user.errors.add(:agree_sharing_of_details_with_lieutenancies, "This field cannot be blank")
    end

    if current_user.errors.empty? && current_user.update(additional_contact_preferences_params)
      redirect_to dashboard_path
    else
      render :additional_contact_preferences
    end
  end

  def complete_registration
    unless current_user.completed_registration
      current_user.update_attribute(:completed_registration, true)

      flash.notice = 'Your account details were successfully saved'
      redirect_to dashboard_path
    else
      redirect_to password_settings_account_path
    end
  end

  def update_password_settings
    current_user.set_step(5)

    if current_user.update_with_password(password_settings_params)
      sign_in(current_user, bypass: true)
      flash.notice = 'Your account details were successfully saved'
      redirect_to dashboard_path
    else
      @active_step = 5
      flash.alert = 'Error updating your password'
      current_user.reload
      render :password_settings
    end
  end

  private

  def correspondent_details_params
    params.require(:user).permit(
      :title,
      :first_name,
      :last_name,
      :job_title,
      :phone_number,
      :email
    )
  end

  def company_details_params
    params.require(:user).permit(
      :company_name,
      :company_address_first,
      :company_address_second,
      :company_city,
      :company_country,
      :company_postcode,
      :company_phone_number
    )
  end

  def contact_settings_params
    params.require(:user).permit(
      :prefered_method_of_contact,
      :subscribed_to_emails,
      :agree_being_contacted_by_department_of_business,
      :qae_info_source_other,
      :qae_info_source,
      :notification_when_innovation_award_open,
      :notification_when_trade_award_open,
      :notification_when_development_award_open,
      :notification_when_mobility_award_open,
      :notification_when_submission_deadline_is_coming,
      :agree_sharing_of_details_with_lieutenancies
    )
  end

  def password_settings_params
    params.require(:user).permit(
      :current_password,
      :password,
      :password_confirmation
    )
  end

  def additional_contact_preferences_params
    params.require(:user).permit(
      :agree_sharing_of_details_with_lieutenancies
    )
  end

end
