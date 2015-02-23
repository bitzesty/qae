class UserDecorator < ApplicationDecorator
  include FullNameDecorator

  def general_info
    "#{object.company_name}: #{full_name}"
  end

  def confirmation_status
    " (Pending)" unless object.confirmed?
  end

  def full_name_with_status
    "#{full_name}#{confirmation_status}"
  end

  def company
    company_name.presence || '<span class="text-muted">N/A</span>'.html_safe
  end

  def role
    object.role.to_s.humanize
  end
end
