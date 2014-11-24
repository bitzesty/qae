unless Admin.exists?
  Admin.create!(email: 'admin@example.com', password: 'admin123')
end

unless User.exists?
  5.times do |i|
    User.create!(email: "user#{i}@example.com", password: 'password')
  end
end
