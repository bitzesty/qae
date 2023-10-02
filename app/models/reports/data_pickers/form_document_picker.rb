module Reports::DataPickers::FormDocumentPicker

  def business_region
    if business_form?
      doc "organization_address_region"
    else
      doc "nominee_personal_address_region"
    end
  end

  def business_reg_no
    if doc("registration_number").to_s.present?
      ActionView::Base.full_sanitizer.sanitize(doc("registration_number").to_s)
    else
      ""
    end
  end

  def unit_website
    doc "website_url"
  end

  def head_surname
    if business_form?
      doc("head_of_business_last_name")
    end
  end

  def head_first_name
    if business_form?
      doc("head_of_business_first_name")
    end
  end

  def head_position
    if business_form?
      doc("head_of_business_job_title") || doc("head_job_title")
    end
  end

  def head_full_name
    if business_form?
      "#{doc('head_of_business_title') || doc('head_of_bussines_title')} #{doc('head_of_business_first_name')} #{doc('head_of_business_last_name')} #{doc('head_of_business_honours')}"
    end
  end

  def personal_honours
    if business_form?
      doc "head_of_business_honours"
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

  def head_of_business_email
    if business_form?
      doc("head_of_business_email") || doc("head_email")
    end
  end

  def head_title
    doc("head_of_business_title")
  end

  def innovation_type
    if innovation? && doc("application_relate_to_header")
      types = doc("application_relate_to_header").map{ |hash| hash["type"] }
      types.join(",")
    else
      ""
    end
  end

  def innovation_description
    if innovation? && doc("innovation_desc_short")
      html_text = doc("innovation_desc_short")
      ActionView::Base.full_sanitizer.sanitize(html_text)
    else
      ""
    end
  end

  def current_queens_award_holder
    awards = obj.previous_wins
    return if !awards || awards.empty?

    categories = PreviousWin::CATEGORIES.invert

    awards.select do |award|
      # this is to support reports for pre and post 2019 awards
      award["outcome"] == "won" || award["outcome"].nil?
    end.map do |award|
      category = categories[award["category"]]
      year = award["year"]

      [category, year].compact.join(" ")
    end.join(", ")
  end

  def principal_postcode
    if business_form?
      doc "organization_address_postcode"
    else
      doc "nominee_personal_address_postcode"
    end.to_s.upcase
  end

  def principal_address1
    if business_form?
      doc "organization_address_building"
    else
      doc "nominee_personal_address_building"
    end
  end

  def principal_address2
    if business_form?
      doc "organization_address_street"
    else
      doc "nominee_personal_address_street"
    end
  end

  def principal_address3
    if business_form?
      doc "organization_address_city"
    else
      doc "nominee_personal_address_city"
    end
  end

  def principal_county
    if business_form?
      if county = doc("organization_address_county")
        county.split(" - ").first
      else
        ""
      end
    else
      doc "nominee_personal_address_county"
    end
  end

  def immediate_parent_country
    country_name(doc_including_hidden("parent_company_country"))
  end

  def organisation_with_ultimate_control_country
    country_name(doc("ultimate_control_company_country"))
  end

  def organisation_with_ultimate_control
    doc("ultimate_control_company")
  end

  def employees
    collect_final_value_from_doc(subcategory_suffix("employees"))
  end

  def export_markets
    return "" unless trade?

    ##
    # need to force String as an Integer will raise
    # undefined method `empty?'
    markets_geo_spread = doc("markets_geo_spread").to_s
    ActionController::Base.helpers.strip_tags(markets_geo_spread)
  end

  def final_year_overseas_sales
    collect_final_value_from_doc(subcategory_suffix("overseas_sales"))
  end

  def final_year_total_sales
    collect_final_value_from_doc(subcategory_suffix("total_turnover"))
  end

  def subcategory_suffix(attr_name)
    mobility_2017_change = {}
    development_2020_change = {}
    innovation_2023_change = {}

    if obj.award_year.year > 2017
      mobility_2017_change = {
        "mobility" => "#{attr_name}_3of3"
      }
    end

    if obj.award_year.year >= 2020
      development_2020_change = {
        "development" => "#{attr_name}_3of3"
      }
    end

    if obj.award_year.year >= 2023
      innovation_2023_change = {
        "innovation" => {
          attr_name => {
            "2 to 3" => "#{attr_name}_2of2",
            "3 to 4" => "#{attr_name}_3of3",
            "4 to 5" => "#{attr_name}_4of4",
            "5 plus" => "#{attr_name}_5of5"
          }
        }
      }
    end

    {
      "trade" => {
        "trade_commercial_success" => {
          "3 to 5" => "#{attr_name}_3of3",
          "6 plus" => "#{attr_name}_6of6"
        }
      },
      "development" => {
        "development_performance_years" => {
          "3 to 5" => "#{attr_name}_3of3",
        }
      },
      "mobility" => {
        "programme_performance_years" => {
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
    }.merge(mobility_2017_change)
     .merge(development_2020_change)
     .merge(innovation_2023_change)[obj.award_type]
  end

  def subcategory_field_name
    {
      "trade" => "trade_commercial_success",
      "development" => "development_performance_years",
      "mobility" => "development_performance_years",
      "innovation" => "innovation_performance_years"
    }[obj.award_type]
  end

  def sub_category
    if mobility?
      # We removed option to choose a period in 2017
      if obj.award_year.year <= 2017
        {
          "2 to 4" => "Outstanding achievement over 2 years",
          "5 plus" => "Continuous achievement over 5 years"
        }[doc(subcategory_field_name)]
      else
        "Outstanding achievement over 3 years"
      end
    elsif development? && obj.award_year.year >= 2020
      "Outstanding achievement over 3 years"
    else
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
  end

  def product_service
    service = if innovation?
      doc("innovation_desc_short")
    elsif development?
      obj.award_year.year <= 2019 ? doc("development_management_approach_briefly") : doc("one_line_description_of_interventions")
    elsif mobility?
      if obj.award_year.year <= 2020
        doc("mobility_desc_short")
      else
        doc("application_category") == "initiative" ? doc("initiative_desc_short") : doc("organisation_desc_short")
      end
    else
      doc("trade_goods_briefly")
    end

    ActionView::Base.full_sanitizer.sanitize(service)
  end

  def date_started_trading
    day = doc("started_trading_day")
    month = doc("started_trading_month")
    year = doc("started_trading_year")

    if year && month && day
      Date.new(year.to_i, month.to_i, day.to_i).strftime("%m/%d/%Y") rescue nil
    end
  end

  def collect_final_value_from_doc(meth)
    if meth
      target_key = nil

      if !(obj.award_year.year <= 2017) && mobility?
        target_key = meth
      elsif obj.award_year.year >= 2020 && development?
        target_key = meth
      elsif obj.award_year.year >= 2024 && innovation?
        question = questions[meth.keys.first.to_sym]&.decorate(answers: answers)

        range = if question.respond_to?(:active_by_year_condition)
                  question.active_by_year_condition&.options&.dig(:data, :identifier)
                else
                  doc(meth.keys.first)
                end

        target_key = meth.values.first[range]
      else
        range = doc(meth.keys.first)
        target_key = meth.values.first[range]
      end

      amended_value = financial_data[target_key]
      amended_value.present? ? amended_value : doc(target_key)
    end
  end

  def immediate_parent_name
    doc_including_hidden("parent_company")
  end

  def doc(key)
    obj.document[key] if key.present? && question_visible?(key)
  end

  # shows hidden questions
  def doc_including_hidden(key)
    obj.document[key]
  end

  def country_name(code)
    if code.present?
      country = ISO3166::Country[code]
      country.name
    end
  end

  def questions
    @_questions ||= obj.award_form.questions_by_key
  end

  def answers
    @_answers ||= HashWithIndifferentAccess.new(obj.document)
  end
end
