class UserDecorator < ApplicationDecorator
  def full_name
    "#{object.first_name} #{object.last_name}"
  end

  def general_info
    "#{object.company_name}: #{full_name}"
  end
end