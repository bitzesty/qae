unless Admin.exists?
  Admin.create!(email: 'admin@example.com', password: 'admin123').tap {|admin| admin.confirm!}
end

unless User.exists?
  5.times do |i|
    User.create!(
      email: "user#{i}@example.com",
      password: 'password',
      agreed_with_privacy_policy: "1"
    )
  end
end

unless Comment.exists?
  FormAnswer.first(3).each do |app|
    app.comments.create(body: "Random comment", author: Admin.last)
  end
end