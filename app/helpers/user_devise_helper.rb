module UserDeviseHelper
  def signup_email_already_exists?(object)
    email = object.errors[:email].first
    email.present? && email == I18n.t(:devise)[:registrations][:already_exist]
  end

  def login_email_or_password_is_incorrect?
    parsed_flash_alert == login_invalid_message
  end

  def login_account_isnt_confirmed?
    parsed_flash_alert == login_unconfirmed_message
  end

  def disable_flash_on_login?
    [login_invalid_message, login_unconfirmed_message].include? parsed_flash_alert
  end

  def login_invalid_message
    I18n.t(:devise)[:failure][:invalid]
        .gsub("%<authentication_keys>s", "email")
  end

  def login_unconfirmed_message
    I18n.t(:devise)[:failure][:unconfirmed]
  end

  def parsed_flash_alert
    message = flash.alert.to_s.strip
  end
end
