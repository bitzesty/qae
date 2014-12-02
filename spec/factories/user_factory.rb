FactoryGirl.define do
  factory :user do
    password { 'strongpass' }
    email
    agreed_with_privacy_policy { '1' }
  end
end
