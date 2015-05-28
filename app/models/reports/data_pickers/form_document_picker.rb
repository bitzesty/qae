module Reports::DataPickers::FormDocumentPicker
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

  def business_sector
    if business_form?
      doc "business_sector"
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
      doc("head_job_title")
    end
  end

  def head_full_name
    if business_form?
      doc("head_of_business_first_name").to_s + doc("head_of_business_last_name").to_s
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

  def nominee_title
    doc "nominee_title"
  end

  def head_email
    if business_form?
      doc "head_email"
    end
  end

  def head_title
    doc("head_of_bussines_title")
  end

  def current_queens_award_holder
    doc "queen_award_holder"
  end

  def principal_postcode
    if business_form?
      doc "principal_address_postcode"
    else
      doc "nominee_personal_address_postcode"
    end.to_s.upcase
  end

  def principal_address3
    if business_form?
      doc "principal_address_city"
    else
      doc "nominee_personal_address_city"
    end
  end

  def principal_address2
    if business_form?
      doc "principal_address_street"
    else
      doc "nominee_personal_address_street"
    end
  end

  def principal_address1
    if business_form?
      doc "principal_address_building"
    else
      doc "nominee_personal_address_building"
    end
  end

  def immediate_parent_country
    doc("parent_company_country")
  end

  def organisation_with_ultimate_control_country
    doc("ultimate_control_company_country")
  end

  def organisation_with_ultimate_control
    bool doc("parent_ultimate_control")
  end

  def employees
    collect_final_value_from_doc(subcategory_suffix("employees"))
  end

  def final_year_overseas_sales
    collect_final_value_from_doc(subcategory_suffix("overseas_sales"))
  end

  def final_year_total_sales
    collect_final_value_from_doc(subcategory_suffix("total_turnover"))
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

  def product_service
    service_json = doc "trade_goods_and_services_explanations"
    if service_json
      (service_json || []).map do |service|
        service["desc_short"]
      end.select(&:present?).join(",")
    end
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
      b = doc meth.keys.first
      doc meth.values.first[b]
    end
  end

  def dcr_checked
    bool(obj.document["corp_responsibility_form"].to_s == "declare_now")
  end

  def immediate_parent
    doc("parent_group_entry")
  end

  def doc(key)
    obj.document[key]
  end
end
