# frozen_string_literal: true

class FormAnswerDecorator < ApplicationDecorator
  AWARD_TITLES = { "Innovation" => "Innovation",
                   "International Trade" => "Int'l Trade",
                   "Sustainable Development" => "Sust. Dev.",
                   "Promoting Opportunity" => "Prom. Opp.",
                   "Enterprise Promotion" => "Ent. Prom."
                 }

  NOT_ASSIGNED = "Not Assigned"
  ASSESSORS_NOT_ASSIGNED = "Assessors are not assigned"

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
    timestamp = Time.zone.now.strftime("%d-%m-%Y_%-l-%M%P")
    "#{object.award_type_full_name.gsub(" ", "_")}_Award_#{timestamp}.pdf"
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
    "The King's Awards for Enterprise: #{object.award_type_full_name} #{object.award_year.try(:year)}"
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

    array_keys.each do |key|
      if attributes.has_key? key
        result = {}

        attributes.each do |k, v|
          if v.is_a?(Hash)
            v.values.each do |value|
              result[k] ||= []

              if value.is_a?(Hash)
                result[k] << value
              end
            end
          end
        end

        old_array = object.document[key]
        new_array = result[key]

        if new_array.any? {|h| h.keys == ["type"]}
          object.document.merge! result
        else
          new_array.each_with_index do |value, index|
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
  end

  def array_keys
    object.document.select{ |item, value| value.kind_of?(Array) }.keys
  end

  def company_name
    company_or_nominee_name
  end

  def nominee_title
    object.nominee_title ? object.nominee_title : document["nominee_title"]
  end

  def progress_class
    "#{object.state.dasherize[0..-2]}"
  end

  def state_text
    I18n.t(object.state.to_s, scope: "form_answers.state")
  end

  def state_short_text
    I18n.t(object.state.to_s, scope: "form_answers.state_short").html_safe
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
      sic = SicCode.find_by(code: object.sic_code)
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
      SicCode.find_by(code: sic).name
    end
  end

  def shortlisted?
    ["recommended", "reserved"].include? object.state
  end

  def corp_responsibility_required_keys
    object.award_form.steps.detect do |step|
      step.short_title == "Declaration of Corporate Responsibility"
    end.questions.select do |q|
      q.is_a?(QaeFormBuilder::TextareaQuestion) && q.required
    end.map(&:key)
       .map(&:to_s)
  end

  def corp_responsibility_missing?
    corp_responsibility_required_keys.any? do |key|
      object.document[key].blank?
    end
  end

  def awarded?
    object.state == "awarded"
  end

  def average_growth_legend(years = [1, 2, 3])
    growths = years.map { |y| average_growth_for(y) }.uniq
    growths.map do |g|
      note = SicCode::NOTES[g]
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
    return nil if document["started_trading_year"].blank?
    "#{document['started_trading_day']}/#{document['started_trading_month']}/#{document['started_trading_year']}".strip
  end

  def website_url
    document["website_url"]
  end

  def head_of_business_title
    document["head_of_business_title"] || document["head__of_bussines_title"]
  end

  def head_of_business_full_name
    "#{document['head_of_business_first_name']} #{document['head_of_business_last_name']}".strip
  end

  def head_of_business_honours
    document["head_of_business_honours"]
  end

  def head_of_business_job_title
    document["head_of_business_job_title"] || document["head_job_title"]
  end

  def head_of_business_email
    document["head_of_business_email"] || document["head_email"]
  end

  def press_contact_details_email
    object.press_summary.try(:email) || document["press_contact_details_email"]
  end

  def press_contact_details_full_name
    p_summary = object.press_summary

    if p_summary.present?
      "#{p_summary.name} #{p_summary.last_name}"
    else
      "#{document['press_contact_details_name']} #{document['press_contact_details_last_name']}"
    end
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
   sanitize_html document["innovation_desc_short"]
  end

  def development_desc_short
    sanitize_html document["development_desc_short"]
  end

  def development_management_approach_briefly
    sanitize_html document["development_management_approach_briefly"]
  end

  def mobility_desc_short
    sanitize_html document["mobility_desc_short"]
  end

  def one_line_description_of_interventions
    sanitize_html document["one_line_description_of_interventions"]
  end

  def goods_and_services_key
    case award_type
    when "innovation"
      "innovation_desc_short"
    when "mobility"
      "mobility_desc_short"
    when "development"
      if award_year.year >= 2020
        "one_line_description_of_interventions"
      else
        "development_management_approach_briefly"
      end
    end
  end

  def goods_and_services
    case award_type
    when "innovation"
      innovation_desc_short
    when "mobility"
      mobility_desc_short
    when "development"
      if award_year.year >= 2020
        one_line_description_of_interventions
      else
        development_management_approach_briefly
      end
    end
  end

  def application_background
    app_background = case award_type
                     when "trade"
                       document["trade_goods_briefly"]
                     when "innovation"
                       document["innovation_desc_short"]
                     when "development"
                       document["development_management_approach_briefly"]
                     when "mobility"
                       document["mobility_desc_short"]
                     end

    sanitize_html app_background
  end

  def organisation_type
    document["organisation_type"]
  end

  def show_this_entry_relates_to_question?
    year = award_year.year

    !promotion? &&
      (!development? || year < 2020) &&
      (!mobility? || year < 2020)
  end
  def this_entry_relates_to
    source_value = if document["application_relate_to"].present?
      document["application_relate_to"]
    elsif document["application_relate_to_header"].present?
      document["application_relate_to_header"]
    end

    source_value.map(&:values).flatten if source_value.present?
  end

  def primary_assessor_full_name
    object.assessors.primary.try(:full_name) || NOT_ASSIGNED
  end

  def secondary_assessor_full_name
    object.assessors.secondary.try(:full_name) || NOT_ASSIGNED
  end

  def primary_assessment_submitted?
    object.assessor_assignments.primary.submitted?
  end

  def secondary_assessment_submitted?
    object.assessor_assignments.secondary.submitted?
  end

  def dashboard_status(user_type = "")
    if object.submitted?
      if user_type.casecmp("admin").zero? && object.state == "assessment_in_progress"
        assessment_in_progress_status
      else
        state_text
      end
    else
      progress_text
    end
  end

  def award_type_and_year
    "#{award_type_full_name} #{award_year.year - 1} - #{award_year.year}"
  end

  def last_updated_at
    latest_update && latest_update.created_at.strftime("%d/%m/%Y")
  end

  def last_updated_by
    latest_update && latest_update.subject.full_name
  end

  private

  def assessment_in_progress_status
    if object.assessors.any?
      names_list = object.assessors.pluck(:first_name, :last_name)
      names_list.map { |first_name, last_name| "#{first_name} #{last_name}" }.join(", ")
    else
      ASSESSORS_NOT_ASSIGNED
    end
  end

  def html_full_sanitizer
    @html_full_sanitizer ||= Rails::Html::FullSanitizer.new
  end

  def sanitize_html(str)
    html_full_sanitizer.sanitize(str)
  end

  def latest_update
    object.audit_logs.data_update.order("created_at").last
  end
end
