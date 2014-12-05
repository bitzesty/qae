FactoryGirl.define do
  factory :user do
    first_name "John"
    last_name "Doe"
    password { 'strongpass' }
    email
    role { 'regular' }
    agreed_with_privacy_policy { '1' }
  end
end
