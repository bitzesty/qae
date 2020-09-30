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
    phone_number { "MyString" }
    additional_info { "MyText" }
    association :palace_invite
  end
end
