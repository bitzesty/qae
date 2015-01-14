FactoryGirl.define do
  factory :support_letter do
    association :supporter
    body "MyText"
  end
end
