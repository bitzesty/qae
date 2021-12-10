class Users::PasswordsController < Devise::PasswordsController
  private

  def successfully_sent?(resource)
    notice = if Devise.paranoid && should_be_paranoid_about?(resource.errors[:email])
      resource.errors.clear
      :send_paranoid_instructions
    elsif resource.errors.empty?
      :send_instructions
    end

    if notice
      set_flash_message! :notice, notice
      true
    end
  end

  def should_be_paranoid_about?(errors)
    errors.count != 1 || errors.first != "This field cannot be blank"
  end
end
