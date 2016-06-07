class FormAnswerDecorator < ApplicationDecorator

  SELECT_BOX_LABELS = FormAnswer::AWARD_TYPE_FULL_NAMES.merge("promotion" => "QAEP")

  AWARD_TITLES = { "Innovation" => "Innovation",
                   "International Trade" => "Int'l Trade",
                   "Sustainable Development" => "Sust. Dev.",
                   "Social Mobility" => "Soc. Mob.",
                   "Enterprise Promotion" => "QAEP",
                   "QAEP" => "QAEP"
                 }

  def pdf_generator(pdf_blank_mode=false)
    "QaePdfForms::Awards2016::#{object.award_type.capitalize}::Base".constantize.new(object, pdf_blank_mode)
  end

  def feedbacks_pdf_generator
    "FeedbackPdfs::Awards2016::#{object.award_type.capitalize}::Base".constantize
                                                                     .new("singular", object, {})
  end

  def case_summaries_pdf_generator
    "CaseSummaryPdfs::Awards2016::#{object.award_type.capitalize}::Base".constantize
                                                                        .new("singular", object, {})
  end

  def pdf_audit_certificate_generator
    "PdfAuditCertificates::Awards2016::#{object.award_type.capitalize}::Base".constantize.
                                                                             new(object)
  end

  def download_filename
    if Settings.after_current_submission_deadline? && object.urn.present?
      "#{object.award_type}_award_#{object.urn}_#{created_at_timestamp}"
    else
      "#{object.award_type}_award_#{created_at_timestamp}"
    end
  end

  def pdf_filename
    "#{download_filename}.pdf"
  end

  def csv_filename
    "#{object.id}_#{download_filename}.csv"
  end

  def application_name
    object.nickname || object.award_type_full_name
  end

  def award_type_slug
    object.award_type
  end

  def award_type_short_name
    AWARD_TITLES[object.class::AWARD_TYPE_FULL_NAMES[object.award_type]]
  end

  def award_application_title
    "#{object.award_type_full_name} Award #{object.award_year.try(:year)}"
  end

  def award_application_title_print
    "The Queen's Awards for Enterprise: #{object.award_type_full_name} #{object.award_year.try(:year)}"
  end

  def company_or_nominee_name
    object.company_or_nominee_name
  end

  def company_nominee_or_application_name
    company_or_nominee_name || application_name
  end

  def data
    #object.document
    OpenStruct.new(object.document.merge(persisted?: true))
  end

  def data_attributes=(attributes)
    object.document.merge! attributes.except(*array_keys)
    # arrays needs special treatment
    # it only works for array of hashes.
    # If you had to update something else, you would need to refactor
    array_keys.each do |key|
      if attributes.has_key? key
        new_array = attributes[key]
        old_array = object.document[key]

        new_array.each do |index, value|
          if index.to_i < old_array.length
            old_array[index.to_i].merge! value
          else
            old_array << value
          end
        end
        old_array.reject!{|i| i.include? "_destroy" }
      end
    end
  end

  def array_keys
    object.document.select{ |item, value|  value.kind_of?(Array) }.keys
  end

  def company_name
    company_or_nominee_name
  end

  def

  def nominee_title
    object.nominee_title ? object.nominee_title : document["nominee_title"]
  end

  def progress_class
    "#{object.state.dasherize[0..-2]}"
  end

  def progress_text_short
    object.state.humanize
  end

  def progress_text
    out = progress_text_short
    out += "...#{fill_progress_in_percents}" if object.application_in_progress?
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

  def shortlisted?
    ["recommended", "reserved"].include? object.state
  end

  def corp_responsibility_required_keys
    object.award_form.steps.detect do |step|
      step.short_title == "Declaration of Corporate Responsibility"
    end.questions.select do |q|
      q.is_a?(QAEFormBuilder::TextareaQuestion) && q.required
    end.map(&:key)
       .map(&:to_s)
  end

  def corp_responsibility_missing?
    corp_responsibility_required_keys.any? do |key|
      object.document[key].blank?
    end
  end

  def full_dcr_selected?
    object.document["corp_responsibility_form"].to_s == "complete_now"
  end

  def short_dcr_selected?
    object.document["corp_responsibility_form"].to_s == "declare_now"
  end

  def awarded?
    object.state == "awarded"
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

  def corp_responsibility_reviewed_changes
    @corp_responsibility_reviewed_changes ||= object.versions.select do |v|
      v["object_changes"].present? &&
      v["object_changes"]["corp_responsibility_reviewed"].present?
    end.last
  end

  def corp_responsibility_reviewed_updated_by
    version = corp_responsibility_reviewed_changes

    if version.present? && version.whodunnit.present?
      user_class, user_id = version.whodunnit.split(":")
      user_class.capitalize
                .constantize
                .find(user_id)
                .decorate
                .full_name
    end
  end

  def corp_responsibility_reviewed_updated_at
    version = corp_responsibility_reviewed_changes
    version.created_at if version.present?
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
      time = transition.created_at.try(:strftime, "%e %b %Y at %-l:%M%P")
      "Updated by #{transition.transitable.decorate.full_name} - #{time}"
    end
  end

  def feedback_updated_by
    feedback = object.feedback
    if feedback && feedback.authorable.present?
      "Updated by: #{feedback.authorable.decorate.full_name} - #{feedback.updated_at.strftime("%e %b %Y at %-l:%M%P")}"
    end
  end

  def press_summary_updated_by
    ps = object.press_summary
    if ps.present? && ps.authorable.present?
      "Updated by #{ps.authorable.decorate.full_name} - #{ps.updated_at.strftime("%e %b %Y at %-l:%M%P")}"
    end
  end

  def nominee_organisation
    document["organization_address_name"]
  end

  def nominee_position
    document["nominee_position"]
  end

  def nominee_building
    document["nominee_personal_address_building"]
  end

  def nominee_street
    document["nominee_personal_address_street"]
  end

  def nominee_city
    document["nominee_personal_address_city"]
  end

  def nominee_county
    document["nominee_personal_address_county"]
  end

  def nominee_postcode
    document["nominee_personal_address_postcode"]
  end

  def nominee_telephone
    document["nominee_phone"]
  end

  def nominee_email
    document["nominee_email"]
  end

  def nominee_region
    document["nominee_personal_address_region"]
  end

  def nominator_name
    "#{document['user_info_first_name']} #{document['user_info_last_name']}".strip
  end

  def nominator_building
    document["personal_address_building"]
  end

  def nominator_street
    document["personal_address_street"]
  end

  def nominator_city
    document["personal_address_city"]
  end

  def nominator_county
    document["personal_address_county"]
  end

  def nominator_postcode
    document["personal_address_postcode"]
  end

  def nominator_telephone
    document["personal_phone"]
  end

  def nominator_email
    document["personal_email"]
  end

  def registration_number
    document["registration_number"]
  end

  def date_started_trading
    return nil if document['started_trading_year'].blank?
    "#{document['started_trading_day']}/#{document['started_trading_month']}/#{document['started_trading_year']}".strip
  end

  def website_url
    document["website_url"]
  end

  def head_of_bussines_title
    document["head_of_bussines_title"]
  end

  def head_of_business_full_name
    "#{document['head_of_business_first_name']} #{document['head_of_business_last_name']}".strip
  end

  def head_of_business_honours
    document["head_of_business_honours"]
  end

  def head_job_title
    document["head_job_title"]
  end

  def head_email
    document["head_email"]
  end

  def applying_for
    document["applying_for"]
  end

  def parent_company
    document["parent_company"]
  end

  def parent_company_country
    document["parent_company_country"]
  end

  def parent_ultimate_control
    document["parent_ultimate_control"]
  end

  def ultimate_control_company
    document["ultimate_control_company"]
  end

  def ultimate_control_company_country
    document["ultimate_control_company_country"]
  end

  def innovation_desc_short
    document["innovation_desc_short"]
  end

  def development_desc_short
    document["development_desc_short"]
  end

  def primary_assessor_full_name
    object.assessors.primary.try(:full_name) || "Not Assigned"
  end

  def secondary_assessor_full_name
    object.assessors.secondary.try(:full_name) || "Not Assigned"
  end

  def primary_assessment_submitted?
    object.assessor_assignments.primary.submitted?
  end

  def secondary_assessment_submitted?
    object.assessor_assignments.secondary.submitted?
  end
end
