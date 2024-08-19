module AuditHelper
  def dummy_user
    User.find_by(email: "dummy_user@example.com") || User.create!(dummy_user_params)
  end

  private

  def dummy_user_params
    {
      email: "dummy_user@example.com",
      password: SecureRandom.base64(16),
      agreed_with_privacy_policy: "1",
      role: "regular",
      first_name: "Unknown",
      last_name: "User",
    }
  end
end
