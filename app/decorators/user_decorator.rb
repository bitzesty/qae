class UserDecorator < ApplicationDecorator
  include UserSharedDecorator

  def general_info
    "#{object.company_name}: #{full_name}"
  end

  def general_info_print
    "<b>#{object.company_name.upcase}"
  end

  def applicant_info_print
    object.company_name || full_name
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

  def role_name
    case object.role.to_s.humanize
    when "Account admin"
      "Admin and contributor"
    when "Regular"
      "Contributor"
    else
      object.role.to_s.humanize
    end
  end
end
