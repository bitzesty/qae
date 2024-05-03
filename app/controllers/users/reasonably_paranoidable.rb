module Users::ReasonablyParanoidable
  private

  def successfully_sent?(resource)
    notice = if Devise.paranoid && should_be_paranoid_about?(resource.errors[:email])
               resource.errors.clear
               :send_paranoid_instructions
             elsif resource.errors.empty?
               :send_instructions
             end

    return unless notice

    set_flash_message! :notice, notice
    true
  end

  def should_be_paranoid_about?(errors)
    errors.count != 1 || errors.first != "This field cannot be blank"
  end
end
