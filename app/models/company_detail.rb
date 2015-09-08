class CompanyDetail < ActiveRecord::Base
  validates :form_answer_id, presence: true
  belongs_to :form_answer

  def self.for(form_answer)
    detail = form_answer.company_detail
    return detail if detail.present?

    form_answer = form_answer.decorate
    args = {
      address_building: form_answer.address_building,
      address_street: form_answer.address_street,
      address_city: form_answer.address_city,
      address_county: form_answer.address_county,
      address_postcode: form_answer.address_postcode,
      telephone: form_answer.telephone,
      region: form_answer.region,
      nominee_organisation: form_answer.nominee_organisation,
      nominee_position: form_answer.nominee_position,
      nominee_organisation_website: form_answer.nominee_organisation_website,
      nominee_building: form_answer.nominee_building,
      nominee_street: form_answer.nominee_street,
      nominee_city: form_answer.nominee_city,
      nominee_county: form_answer.nominee_county,
      nominee_postcode: form_answer.nominee_postcode,
      nominee_telephone: form_answer.nominee_telephone,
      nominee_email: form_answer.nominee_email,
      nominee_region: form_answer.nominee_region,
      nominator_name: form_answer.nominator_name,
      nominator_building: form_answer.nominator_building,
      nominator_street: form_answer.nominator_street,
      nominator_city: form_answer.nominator_city,
      nominator_county: form_answer.nominator_county,
      nominator_postcode: form_answer.nominator_postcode,
      nominator_telephone: form_answer.nominator_telephone,
      nominator_email: form_answer.nominator_email,
      registration_number: form_answer.registration_number,
      date_started_trading: form_answer.date_started_trading,
      website_url: form_answer.website_url,
      head_of_bussines_title: form_answer.head_of_bussines_title,
      head_of_business_full_name: form_answer.head_of_business_full_name,
      head_of_business_honours: form_answer.head_of_business_honours,
      head_job_title: form_answer.head_job_title,
      head_email: form_answer.head_email,
      applying_for: form_answer.applying_for,
      parent_company: form_answer.parent_company,
      parent_company_country: form_answer.parent_company_country,
      parent_ultimate_control: form_answer.parent_ultimate_control,
      ultimate_control_company: form_answer.ultimate_control_company,
      ultimate_control_company_country: form_answer.ultimate_control_company_country,
      innovation_desc_short: form_answer.innovation_desc_short,
      development_desc_short: form_answer.development_desc_short
    }
    form_answer.create_company_detail(args)
  end
end
