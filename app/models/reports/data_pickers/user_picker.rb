module Reports::DataPickers::UserPicker
  delegate :user, to: :obj

  def contact_title
    user.try(:title)
  end

  def contact_first_name
    user.try(:first_name)
  end

  def contact_surname
    user.try(:last_name)
  end

  def contact_position
    user.try(:job_title)
  end

  def contact_email
    user.try(:email)
  end

  def contact_telephone
    user.try(:phone_number)
  end

  def address_line1
    user.try(:company_address_first)
  end

  def address_line2
    user.try(:company_address_second)
  end

  def address_line3
    user.try(:company_city)
  end

  def postcode
    user.try(:company_postcode)
  end

  def telephone1
    user.try(:phone_number)
  end

  def telephone2
    user.try(:company_phone_number)
  end

  def qae_info_source
    user.try(:qae_info_source)
  end

  def qae_info_source_other
    user.try(:qae_info_source_other)
  end

  def user_creation_date
    user.try(:created_at)
  end

  def company_name
    user.try(:company_name)
  end

  def organisation_name
    obj.company_or_nominee_name
  end

  def qao_permission
    bool user.try(:subscribed_to_emails)
  end
end
