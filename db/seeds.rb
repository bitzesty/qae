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

roles = ["lead", "regular", "none"]
awards = ["trade", "innovation", "development", "promotion"]

awards.each do |award|
  roles.each do |role|
    assessor_args = {
      email: "#{role}-assessor-#{award}@example.com",
      first_name: "#{role}-assessor",
      last_name: "#{award}",
    }
    role_args = {
      "#{award}_role" => (role == "none" ? nil : role)
    }

    assessor_args.merge!(role_args)

    a = Assessor.where(assessor_args).first_or_initialize
    a.password = "assessor123"
    a.save!
    a.tap(&:confirm!) unless a.confirmed?
  end
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
