unless Admin.exists?
  admin_args = {
    email: "admin@example.com",
    password: "^#ur9EkLm@1W",
    first_name: "First name",
    last_name: "Last name",
    confirmed_at: DateTime.now,
  }

  Admin.create!(admin_args)
  p "========Admin created========"
end

unless Assessor.exists?
  assessor_args = {
    email: "assessor@example.com",
    password: "^#ur9EkLm@1W",
    first_name: "First name",
    last_name: "Last name",
    confirmed_at: DateTime.now,
  }

  Assessor.create!(assessor_args)
  p "========Assessor created========"
end

roles = %w[lead regular none]
awards = %w[trade innovation development promotion mobility]

awards.each do |award|
  roles.each do |role|
    assessor_args = {
      email: "#{role}-assessor-#{award}@example.com",
      first_name: "#{role}-assessor",
      last_name: "#{award}",
    }
    role_args = {
      "#{award}_role" => (role == "none" ? nil : role),
    }

    assessor_args.merge!(role_args)

    a = Assessor.where(assessor_args).first_or_initialize
    a.password = "^#ur9EkLm@1W"
    a.confirmed_at ||= DateTime.now
    a.save!
  end
end
p "========Other assessors created========"
