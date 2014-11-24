FactoryGirl.define do
  factory :user do
    password { 'strongpass' }
    email
  end
end
