FactoryGirl.define do
  factory :comment do
    body 'Comment body'
    authorable { create(:admin) }
  end
end
