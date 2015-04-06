class FormAnswerDecorator < ApplicationDecorator

  SELECT_BOX_LABELS = FormAnswer::AWARD_TYPE_FULL_NAMES.merge("promotion" => "QAEP")

  AWARD_TITLES = { "Innovation" => "Innovation",
                   "International Trade" => "Intl Trade",
                   "Sustainable Development" => "Sus Dev",
                   "Enterprise promotion" => "QAEP",
                   "QAEP" => "QAEP"
                 }

  def pdf_generator
    "QaePdfForms::Awards2014::#{object.award_type.capitalize}::Base".constantize.new(object)
  end

  def feedbacks_pdf_generator
    "FeedbackPdfs::Awards2014::#{object.award_type.capitalize}::Base".constantize.new(object)
  end

  def pdf_audit_certificate_generator
    "PdfAuditCertificates::Awards2014::#{object.award_type.capitalize}::Base".constantize.
                                                                             new(object)
  end

  def download_filename
    "#{object.award_type}_award_#{created_at}"
  end

  def pdf_filename
    "#{download_filename}.pdf"
  end

  def csv_filename
    "#{object.id}_#{download_filename}.csv"
  end

  def award_type
    # TODO: remove this !
    object.class::AWARD_TYPE_FULL_NAMES[object.award_type]
  end

  def application_name
    object.nickname || award_type
  end

  def award_type_slug
    object.award_type
  end

  def award_type_short_name
    AWARD_TITLES[object.class::AWARD_TYPE_FULL_NAMES[object.award_type]]
  end

  def award_application_title
    "#{award_type} Award #{Date.today.year}"
  end

  def company_or_nominee_name
    object.company_or_nominee_name
  end

  def company_name
    company_or_nominee_name
  end

  def progress_class
    "#{object.state.dasherize[0..-2]}"
  end

  def progress_text_short
    object.state.humanize
  end

  def progress_text
    out = progress_text_short
    out += "...#{fill_progress_in_percents}" if object.state == "application_in_progress"
    out
  end

  def average_growth_for(year)
    if object.sic_code.present?
      sic = SICCode.find_by_code(object.sic_code)
      sic.by_year(year) if sic
    end
  end

  def all_average_growths
    res = {}
    (1..6).each { |y| res[y] = average_growth_for(y) }
    res
  end

  def sic_code_name
    sic = object.sic_code
    if sic.present?
      SICCode.find_by_code(sic).name
    end
  end

  def average_growth_legend(years = [1, 2, 3])
    growths = years.map { |y| average_growth_for(y) }.uniq
    growths.map do |g|
      note = SICCode::NOTES[g]
      "#{g} - #{note}" if note
    end.compact.join("\n")
  end

  def financial_summary_updated_by
    return unless object.financial_data

    id = object.financial_data["updated_by_id"]
    kind = object.financial_data["updated_by_type"]

    if id && kind
      if %w[Admin Assessor].include?(kind)
        user = kind.constantize.find_by_id(id)

        user.decorate.full_name if user
      end
    end
  end

  def financial_summary_updated_at
    object.financial_data && object.financial_data["updated_at"]
  end

  def lead_assessors
    award_leads = Assessor.leads_for(object.award_type)

    if award_leads.any?
      award_leads.map(&:full_name).join(", ")
    else
      "<span class='p-empty'>Not assigned</span>".html_safe
    end
  end

  def last_state_updated_by
    transition = object.state_machine.last_transition
    if transition.present? && transition.transitable
      time = transition.created_at.try(:strftime, "%e %b %Y at %H:%M")
      "Updated by #{transition.transitable.decorate.full_name} - #{time}"
    end
  end

  def address_building
    document["principal_address_building"].presence ||
      document["organization_address_building"]
  end

  def address_street
    document["principal_address_street"] ||
      document["organization_address_street"]
  end

  def address_city
    document["principal_address_city"] ||
      document["organization_address_city"]
  end

  def address_country
    document["principal_address_country"] ||
      document["organization_address_country"]
  end

  def address_postcode
    document["principal_address_postcode"] ||
      document["organization_address_postcode"]
  end

  def telephone
    document["org_telephone"]
  end

  def region
    document["principal_address_region"] ||
      document["organization_address_region"]
  end
end
