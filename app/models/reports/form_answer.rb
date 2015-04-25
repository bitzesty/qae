# represents the FormAnswer object in report generation context
class Reports::FormAnswer
  attr_reader :obj, :award_form

  def initialize(form_answer)
    @obj = form_answer
    answers = ActiveSupport::HashWithIndifferentAccess.new(obj.document || {})
    @award_form = @obj.award_form.decorate(answers: answers)
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

  def final_year_total_sales
    meth = subcategory_suffix("overseas_sales")
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
    end
  end

  def principal_address2
    if business_form?
      doc "principal_address_street"
    end
  end

  def principal_address3
    if business_form?
      doc "principal_address_city"
    end
  end

  def principal_postcode
    if business_form?
      doc "principal_address_postcode"
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

  def title
    obj.user.title
  end

  def first_name
    obj.user.first_name
  end

  def last_name
    obj.user.last_name
  end

  def first_assessor
    obj.assessors.primary.try(:full_name)
  end

  def second_assessor
    obj.assessors.secondary.try(:full_name)
  end

  def first_assessment_complete
    bool(obj.assessor_assignments.primary.try(:submitted?))
  end

  def second_assessment_complete
    bool(obj.assessor_assignments.secondary.try(:submitted?))
  end

  def case_summary_overall_grade
    obj.assessor_assignments.lead_case_summary.try(:verdict_rate)
  end

  def head_email
    obj.user.email
  end

  def head_full_name
    if  business_form?
      doc("head_of_business_first_name").to_s + doc("head_of_business_last_name").to_s
    end
  end

  def head_position
    if business_form?
      doc("head_job_title")
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
    obj.user.subscribed_to_emails
  end

  def user_creation_date
    obj.user.created_at
  end

  def section1
    f_progress(award_form.steps[0])
  end

  def section2
    f_progress(award_form.steps[1])
  end

  def section3
    f_progress(award_form.steps[2])
  end

  def section4
    f_progress(award_form.steps[3])
  end

  def section5
    f_progress(award_form.steps[4])
  end

  def section6
    f_progress(award_form.steps[6])
  end

  def personal_honours
    if business_form?
      doc "head_of_business_honours"
    else
      # TODO: clarify
    end
  end

  def f_progress(p)
    return "-" unless p
    ((p.progress || 0) * 100).round.to_s + "%"
  end

  def current_queens_award_holder
    doc "queen_award_holder"
  end

  def date_started_trading
    day = doc("started_trading_day")
    month = doc("started_trading_month")
    year = doc("started_trading_year")
    "#{month}/#{day}/#{year}" if year && month && day
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

  def bool var
    var ? "Yes" : "No"
  end
end
