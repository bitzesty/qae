unless Admin.exists?
  admin_args = {
    email: "admin@example.com",
    password: "admin123",
    first_name: "First name",
    last_name: "Last name"
  }

  Admin.create!(admin_args).
    tap(&:confirm!)
end

unless Assessor.exists?
  assessor_args = {
    email: "assessor@example.com",
    password: "assessor123",
    first_name: "First name",
    last_name: "Last name"
  }

  Assessor.create!(assessor_args).tap(&:confirm!)
end

# unless User.exists?
#   5.times do |i|
#     User.create!(
#       email: "user#{i}@example.com",
#       password: 'password',
#       agreed_with_privacy_policy: "1"
#     )
#   end
# end

# unless Comment.exists?
#   FormAnswer.first(3).each do |app|
#     app.comments.create(body: "Random comment", author: Admin.last)
#   end
# end
