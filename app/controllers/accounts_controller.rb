class AccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :restrict_access_if_admin_in_read_only_mode!

  def correspondent_details
    @active_step = 1
  end

  def company_details
    @active_step = 2
  end

  def contact_settings
    @active_step = 3
  end

  def password_settings
    @active_step = 5
  end

  def update_correspondent_details
    current_user.set_step(1)
    if current_user.update(correspondent_details_params)
      redirect_to company_details_account_path
    else
      @active_step = 1
      render :correspondent_details
    end
  end

  def update_company_details
    current_user.set_step(2)
    if current_user.update(company_details_params)
      redirect_to contact_settings_account_path
    else
      @active_step = 2
      render :company_details
    end
  end

  def update_contact_settings
    current_user.set_step(3)
    if current_user.update(contact_settings_params)

      if current_user.role.regular?
        current_user.update_attribute(:completed_registration, true)
        flash.notice = 'You account details were successfully saved'
        redirect_to dashboard_path
      else
        redirect_to account_collaborators_path
      end
    else
      @active_step = 3
      render :contact_settings
    end
  end

  def complete_registration
    unless current_user.completed_registration
      current_user.update_attribute(:completed_registration, true)

      flash.notice = 'You account details were successfully saved'
      redirect_to dashboard_path
    else
      redirect_to password_settings_account_path
    end
  end

  def update_password_settings
    current_user.set_step(5)
    if current_user.update(password_settings_params)
      flash.notice = 'You account details were successfully saved'
      redirect_to dashboard_path
    else
      @active_step = 5
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
      :phone_number
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
      { qae_info_source: [] }
    )
  end

  def password_settings_params
    params.require(:user).permit(
      :current_password,
      :password,
      :password_confirmation
    )
  end
end
