FactoryGirl.define do
  factory :comment do
    body 'Comment body'
    author{ create(:user)}
  end
end
