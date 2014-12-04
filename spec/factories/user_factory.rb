FactoryGirl.define do
  factory :user do
    password { 'strongpass' }
    email
    role { 'regular' }
    agreed_with_privacy_policy { '1' }
  end
end
