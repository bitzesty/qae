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
      address_country: form_answer.address_country,
      address_postcode: form_answer.address_postcode,
      telephone: form_answer.telephone,
      region: form_answer.region,
      nominee_title: form_answer.nominee_title
    }
    form_answer.create_company_detail(args)
  end
end
