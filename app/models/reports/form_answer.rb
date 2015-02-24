# represents the FormAnswer object in report generation context
class Reports::FormAnswer
  attr_reader :obj

  def initialize(form_answer)
    @obj = form_answer
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

  private

  def address_line1
    doc (business_form? ? "principal_address_building" : "nominee_personal_address_building")
  end

  def address_line2
    doc (business_form? ? "principal_address_street" : "nominee_personal_address_street")
  end

  def address_line3
    doc (business_form? ? "principal_address_city" : "nominee_personal_address_city")
  end

  def postcode
    doc (business_form? ? "principal_address_postcode" : "nominee_personal_address_postcode")
  end

  def telephone1
    doc (business_form? ? "org_telephone" : "nominee_phone")
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
    doc (business_form? ? "head_of_business_title" : "nominee_title")
  end

  def first_name
    doc (business_form? ? "head_of_business_first_name" : "nominee_first_name")
  end

  def last_name
    if business_form?
      doc "head_of_business_last_name"
    end
    doc (business_form? ? "head_of_business_last_name" : "nominee_last_name")
  end

  def head_email
    doc (business_form? ? "head_email" : "nominee_email")
  end

  def company_name
    doc (business_form? ? "company_name" : "organization_name")
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

  def qao_permission
    obj.user.subscribed_to_emails
  end

  def business_form?
    obj.trade? || obj.innovation? || obj.development?
  end

  def promotion?
    obj.promotion?
  end

  def doc(key)
    obj.document[key]
  end
end
