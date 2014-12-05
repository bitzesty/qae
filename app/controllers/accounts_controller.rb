class AccountsController < ApplicationController
  before_action :check_eligibility

  def correspondent_details
    @active_step = 1
  end

  def company_details
    @active_step = 2
  end

  def contact_settings
    @active_step = 3
  end

  def add_collaborators
    @active_step = 4
  end

  def password_settings
    @active_step = 5
  end

  def update_correspondent_details
    current_user.setStep(1)
    if current_user.update(correspondent_details_params)
      redirect_to company_details_account_path
    else
      @active_step = 1
      render :correspondent_details
    end
  end

  def update_company_details
    current_user.setStep(2)
    if current_user.update(company_details_params)
      redirect_to contact_settings_account_path
    else
      @active_step = 2
      render :company_details
    end
  end

  def update_contact_settings
    current_user.setStep(3)
    if current_user.update(contact_settings_params)
      redirect_to add_collaborators_account_path
    else
      @active_step = 3
      render :contact_settings
    end
  end

  def update_add_collaborators
    if current_user.update(add_collaborators_settings_params)
      unless current_user.completed_registration
        flash.notice = 'Account was successfully created'
        redirect_to dashboard_path
      else
        redirect_to password_settings_account_path
      end
    else
      @active_step = 5
      render :add_collaborators
    end
  end

  def update_password_settings
    current_user.setStep(5)
    if current_user.update(password_settings_params)
      flash.notice = 'Account was successfully updated'
      redirect_to dashboard_path
    else
      @active_step = 5
      render :password_settings
    end
  end

  private

  def correspondent_details_params
    params.require(:user).permit(:title, :first_name, :last_name, :job_title, :phone_number)
  end

  def company_details_params
    params.require(:user).permit(:company_name, :company_address_first, :company_address_second, :company_city, :company_country, :company_postcode, :company_phone_number)
  end

  def contact_settings_params
    params.require(:user).permit(:prefered_method_of_contact, :subscribed_to_emails, :qae_info_source_other, { qae_info_source: [] })
  end

  def add_collaborators_settings_params
    # TODO use real params
    params.require(:user).permit(:prefered_method_of_contact, :subscribed_to_emails, :qae_info_source_other, { qae_info_source: [] })
  end

  def password_settings_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end

  private

  def check_eligibility
    if !current_user.eligibility || !current_user.eligibility.passed?
      redirect_to eligibility_path
    end
  end
end
