class UserDecorator < ApplicationDecorator
  include UserSharedDecorator

  def general_info
    "#{object.company_name}: #{full_name}"
  end

  def general_info_print
    if object.company_name.present?
      "<b>#{object.company_name.upcase}:</b> #{full_name.upcase}"
    else
      full_name.upcase
    end
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
    if account.owner == self
      "Account owner"
    else
      case role.to_s.humanize
      when "Account admin"
        "Admin and collaborator"
      when "Regular"
        "Collaborator only"
      else
        role.to_s.humanize
      end
    end
  end

  def debounce_api_check_last_run
    object.debounce_api_latest_check_at
  end

  def debounce_api_check_next_run
    debounce_api_check_last_run + 6.months
  end

  def debounce_api_check_cycle_details
    "Last check: #{date_format(debounce_api_check_last_run)}, Next check: #{date_format(debounce_api_check_next_run)}"
  end

  def date_format(val)
    val.strftime("%d %b %Y")
  end
end
