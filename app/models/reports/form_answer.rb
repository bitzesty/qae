class Reports::FormAnswer
  attr_reader :obj, :award_form

  def initialize(form_answer)
    @obj = form_answer
    @moderated = @obj.assessor_assignments.detect { |a| a.position == "moderated" }
    @primary = @obj.assessor_assignments.detect { |a| a.position == "primary" }
    @secondary = @obj.assessor_assignments.detect { |a| a.position == "secondary" }
    @lead_case_summary = @obj.assessor_assignments.detect { |a| a.position == "lead_case_summary" }
    @primary_assessor = @obj.primary_assessor
    @secondary_assessor = @obj.secondary_assessor
  end

  def call_method(methodname)
    return "not implemented" if methodname.blank?

    if respond_to?(methodname, true)
      send(methodname)
    elsif obj.respond_to?(methodname)
      obj.send(methodname)
    else
      "missing method"
    end
  end

  def employees
    meth = subcategory_suffix("employees")
    if meth
      b = doc meth.keys.first
      doc meth.values.first[b]
    end
  end

  private

  def final_year_overseas_sales
    meth = subcategory_suffix("overseas_sales")
    if meth
      b = doc meth.keys.first
      doc meth.values.first[b]
    end
  end

  def final_year_total_sales
    meth = subcategory_suffix("total_turnover")
    if meth
      b = doc meth.keys.first
      doc meth.values.first[b]
    end
  end

  def subcategory_suffix(attr_name)
    {
      "trade" => {
        "trade_commercial_success" => {
          "3 to 5" => "#{attr_name}_3of3",
          "6 plus" => "#{attr_name}_6of6"
        }
      },
      "development" => {
        "development_performance_years" => {
          "2 to 4" => "#{attr_name}_2of2",
          "5 plus" => "#{attr_name}_5of5"
        }
      },
      "innovation" => {
        "innovation_performance_years" => {
          "2 to 4" => "#{attr_name}_2of2",
          "5 plus" => "#{attr_name}_5of5"
        }
      }
    }[obj.award_type]
  end

  def subcategory_field_name
    {
      "trade" => "trade_commercial_success",
      "development" => "development_performance_years",
      "innovation" => "innovation_performance_years"
    }[obj.award_type]
  end

  def sub_category
    if trade?
      {
        "3 to 5" => "Outstanding growth in the last 3 years",
        "6 plus" => "Continuous growth in the last 6 years"
      }
    elsif innovation?
      {
        "2 to 4" => "Outstanding performance improvements in the last 2 years",
        "5 plus" => "Steady performance improvements in the last 5 years"
      }
    elsif development?
      {
        "2 to 4" => "Outstanding achievement over 2 years",
        "5 plus" => "Continuous achievement over 5 years"
      }
    else
      {}
    end[doc(subcategory_field_name)]
  end

  def feedback_complete
    bool(obj.feedback.present?)
  end

  def dcr_checked
    bool(obj.document["corp_responsibility_form"].to_s == "declare_now")
  end

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

  def ac_received
    bool obj.audit_certificate.present?
  end

  def ac_checked
    bool obj.audit_certificate.try(:reviewed?)
  end

  def case_assigned
    bool(obj.primary_assessor_id.present? && obj.secondary_assessor_id.present?)
  end

  def case_withdrawn
    bool(obj.state == "withdrawn")
  end

  def principal_address1
    if business_form?
      doc "principal_address_building"
    else
      doc "nominee_personal_address_building"
    end
  end

  def principal_address2
    if business_form?
      doc "principal_address_street"
    else
      doc "nominee_personal_address_street"
    end
  end

  def principal_address3
    if business_form?
      doc "principal_address_city"
    else
      doc "nominee_personal_address_city"
    end
  end

  def principal_postcode
    if business_form?
      doc "principal_address_postcode"
    else
      doc "nominee_personal_address_postcode"
    end
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

  def percentage_complete
    obj.fill_progress_in_percents
  end

  def qae_info_source
    obj.user.qae_info_source
  end

  def qae_info_source_other
    obj.user.qae_info_source_other
  end

  def immediate_parent_country
    doc("parent_company_country")
  end

  def organisation_with_ultimate_control
    bool doc("parent_ultimate_control")
  end

  def mso_outcome_agreed
    rag @moderated.try(:verdict_rate)
  end

  def organisation_with_ultimate_control_country
    doc("ultimate_control_company_country")
  end

  def mso_grade_agreed
    return unless @moderated
    rates = @moderated.document.select { |k, _| k =~ /\w_rate/ }
    rates.map do |_, rate|
      rag rate
    end.join(",")
  end

  def immediate_parent
    doc("parent_group_entry")
  end

  def first_assessor
    @primary_assessor.try(:full_name)
  end

  def second_assessor
    @secondary_assessor.try(:full_name)
  end

  def first_assessment_complete
    bool(@primary.try(:submitted?))
  end

  def second_assessment_complete
    bool(@secondary.try(:submitted?))
  end

  def case_summary_overall_grade
    rag(@lead_case_summary.try(:verdict_rate))
  end

  def head_email
    if business_form?
      doc "head_email"
    end
  end

  def head_title
    doc("head_of_bussines_title")
  end

  def head_full_name
    if business_form?
      doc("head_of_business_first_name").to_s + doc("head_of_business_last_name").to_s
    end
  end

  def head_position
    if business_form?
      doc("head_job_title")
    end
  end

  def head_first_name
    if business_form?
      doc("head_of_business_first_name")
    end
  end

  def head_surname
    if business_form?
      doc("head_of_business_last_name")
    end
  end

  def company_name
    obj.user.company_name
  end

  def business_sector
    if business_form?
      doc "business_sector"
    end
  end

  def business_sector_other
    if business_form?
      doc "business_sector_other"
    end
  end

  def business_region
    if business_form?
      doc "principal_address_region"
    else
      doc "nominee_personal_address_region"
    end
  end

  def business_reg_no
    doc "registration_number"
  end

  def unit_website
    doc "website_url"
  end

  def qao_permission
    bool obj.user.subscribed_to_emails
  end

  def user_creation_date
    obj.user.created_at
  end

  def section1
    obj.form_answer_progress.try(:section, 1)
  end

  def section2
    obj.form_answer_progress.try(:section, 2)
  end

  def section3
    obj.form_answer_progress.try(:section, 3)
  end

  def section4
    obj.form_answer_progress.try(:section, 4)
  end

  def section5
    obj.form_answer_progress.try(:section, 5)
  end

  def section6
    obj.form_answer_progress.try(:section, 6)
  end

  def personal_honours
    if business_form?
      doc "head_of_business_honours"
    end
  end

  def product_service
    service_json = doc "trade_goods_and_services_explanations"
    if service_json
      service_json.gsub!(/[\\]" | ["]/x, '\"' => '"', '"' => "")

      begin
        services = JSON.parse(service_json)
      rescue JSON::ParseError
        services = []
      end

      services.map do |service|
        service["desc_short"]
      end.select(&:present?).join(",")

    end
  end

  def current_queens_award_holder
    doc "queen_award_holder"
  end

  def date_started_trading
    day = doc("started_trading_day")
    month = doc("started_trading_month")
    year = doc("started_trading_year")
    if year && month && day
      Date.new(year.to_i, month.to_i, day.to_i).strftime("%m/%d/%Y")
    end
  end

  def nominee_first_name
    doc "nominee_info_first_name"
  end

  def nominee_surname
    doc "nominee_info_last_name"
  end

  def nominee_email
    doc "nominee_email"
  end

  def nominee_title
    doc "nominee_title"
  end

  def category
    obj.class::AWARD_TYPE_FULL_NAMES[obj.award_type]
  end

  def business_form?
    obj.trade? || obj.innovation? || obj.development?
  end

  def trade?
    obj.trade?
  end

  def development?
    obj.development?
  end

  def promotion?
    obj.promotion?
  end

  def innovation?
    obj.innovation?
  end

  def doc(key)
    obj.document[key]
  end

  def bool(var)
    var ? "Yes" : "No"
  end

  def rag(var)
    {
      "negative" => "R",
      "positive" => "G",
      "average" => "A"
    }[var]
  end
end
