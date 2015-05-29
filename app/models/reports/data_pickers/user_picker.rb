module Reports::DataPickers::UserPicker
  def contact_title
    obj.user.title
  end

  def contact_first_name
    obj.user.first_name
  end

  def contact_surname
    obj.user.last_name
  end

  def contact_position
    obj.user.job_title
  end

  def contact_email
    obj.user.email
  end

  def contact_telephone
    obj.user.phone_number
  end

  def address_line1
    obj.user.company_address_first
  end

  def address_line2
    obj.user.company_address_second
  end

  def address_line3
    obj.user.company_city
  end

  def postcode
    obj.user.company_postcode
  end

  def telephone1
    obj.user.phone_number
  end

  def telephone2
    obj.user.company_phone_number
  end

  def qae_info_source
    obj.user.qae_info_source
  end

  def qae_info_source_other
    obj.user.qae_info_source_other
  end

  def user_creation_date
    obj.user.created_at
  end

  def company_name
    obj.user.company_name
  end

  def qao_permission
    bool obj.user.subscribed_to_emails
  end
end
