class UserDecorator < ApplicationDecorator
  def full_name
    "#{object.first_name} #{object.last_name}"
  end

  def general_info
    "#{object.company_name}: #{full_name}"
  end

  def confirmation_status
    " (Pending)" unless object.confirmed?
  end

  def full_name_with_status
    "#{full_name}#{confirmation_status}"
  end

  def role
    object.role.humanize
  end
end