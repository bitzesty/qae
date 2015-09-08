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
      nominee_title: form_answer.nominee_title,
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
      nominator_email: form_answer.nominator_email
    }
    form_answer.create_company_detail(args)
  end
end
