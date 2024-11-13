FactoryBot.define do
  factory :palace_attendee do
    title { "MyString" }
    first_name { "MyString" }
    last_name { "MyString" }
    job_name { "MyString" }
    post_nominals { "MyString" }
    address_1 { "MyString" }
    address_2 { "MyString" }
    address_3 { "MyString" }
    address_4 { "MyString" }
    postcode { "MyString" }
    sequence(:phone_number) { |n| "020 4551 008#{n.to_s[-1]}" }
    disabled_access { false }
    additional_info { "MyText" }
    has_royal_family_connections { false }
    association :palace_invite
  end
end
