require "rails_helper"

describe CustomEmailForm do
  let!(:admin) { create :admin }
  let(:form) do
    CustomEmailForm.new(admin_id: admin.id,
      scope: scope,
      message: "message",
      subject: "subject")
  end

  context "myself" do
    let(:scope) { "myself" }

    it "sends email to myself" do
      expect(form.users).to eq([admin])
    end
  end

  context "qae_opt_in_group" do
    let(:scope) { "qae_opt_in_group" }

    it "sends email to users with qae_opt_in_group" do
      user_1 = create(:user, subscribed_to_emails: true, email: "1@example.com")
      create(:user, subscribed_to_emails: false, email: "2@example.com")
      user_3 = create(:user, subscribed_to_emails: true, email: "3@example.com")

      expect(form.users).to eq([user_1, user_3])
    end
  end

  context "bis_opt_in" do
    let(:scope) { "bis_opt_in" }

    it "sends email to users with bis_opt_in" do
      user_1 = create(:user, agree_being_contacted_by_department_of_business: true, email: "1@example.com")
      create(:user, agree_being_contacted_by_department_of_business: false, email: "2@example.com")
      user_3 = create(:user, agree_being_contacted_by_department_of_business: true, email: "3@example.com")

      expect(form.users).to eq([user_1, user_3])
    end
  end

  context "assessors" do
    let(:scope) { "assessors" }

    it "sends email to all assessors" do
      user_1 = create(:assessor, email: "1@example.com")
      user_2 = create(:assessor, email: "2@example.com")
      user_3 = create(:assessor, email: "3@example.com")

      expect(form.users).to eq([user_1, user_2, user_3])
    end
  end

  context "all_users" do
    let(:scope) { "all_users" }

    it "sends email to all users" do
      user_1 = create(:user, email: "1@example.com")
      user_2 = create(:user, email: "2@example.com")
      user_3 = create(:user, email: "3@example.com")

      expect(form.users).to eq([user_1, user_2, user_3])
    end
  end
end
