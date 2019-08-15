shared_context "devise mailers instructions" do
  describe "#send_confirmation_instructions" do
    it "should send email with confirmation instructions" do
      text = "You can confirm your email account using link below"
      user.send_confirmation_instructions
      email = ActionMailer::Base.deliveries.last
      expect(email.body.raw_source).to include(text)
    end
  end

  describe "#send_unlock_instructions" do
    it "should send email with unlock instructions" do
      text = "Your account has been locked due to an excessive number of unsuccessful sign in attempts."
      user.send_unlock_instructions
      email = ActionMailer::Base.deliveries.last
      expect(email.body.raw_source).to include(text)
    end
  end

  describe "#send_reset_password_instructions" do
    it "should send email with password reset instructions" do
      text = "You are receiving this email because someone requested to reset your password."
      user.send_reset_password_instructions
      email = ActionMailer::Base.deliveries.last
      expect(email.body.raw_source).to include(text)
    end
  end
end
