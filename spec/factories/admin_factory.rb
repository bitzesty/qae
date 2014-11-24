FactoryGirl.define do
  sequence :email do |n|
    "foo#{n}@example.com"
  end

  factory :admin do
    password { 'strongpass' }
    email
  end
end
