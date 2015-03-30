FactoryGirl.define do
  factory :user do
    first_name "John"
    last_name "Doe"
    password { "my98strong pass12 31415926" }
    email
    role { 'regular' }
    agreed_with_privacy_policy { '1' }
    sequence(:phone_number) { |n| "1111111#{n}"}
    confirmed_at Time.zone.now

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

      after(:create) do |user|
        create(:basic_eligibility, account: user.account)
        create(:trade_eligibility, account: user.account)
        create(:development_eligibility, account: user.account)
        create(:innovation_eligibility, account: user.account)
      end
    end

  end
end
