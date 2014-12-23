FactoryGirl.define do
  factory :user do
    first_name "John"
    last_name "Doe"
    password { 'strongpass' }
    email
    role { 'regular' }
    agreed_with_privacy_policy { '1' }
    sequence(:phone_number) { |n| "1111111#{n}"}

    trait :completed_profile do
      title "Director"
      job_title "Director"
      company_name "Test Company"
      company_address_first "Jameson St 6, 28"
      company_address_second "Jameson St 6, 28"
      company_city "London"
      company_country "GB"
      company_postcode "SE16 3SA"
      sequence(:company_phone_number) { |n| "7777777#{n}"}
      prefered_method_of_contact "phone"
      qae_info_source "govuk"
      role "regular"
      completed_registration true
    end

    trait :eligible do
      completed_profile
      association :basic_eligibility, factory: :basic_eligibility
      association :innovation_eligibility, factory: :innovation_eligibility
      association :development_eligibility, factory: :development_eligibility
      association :trade_eligibility, factory: :trade_eligibility
    end

  end
end
