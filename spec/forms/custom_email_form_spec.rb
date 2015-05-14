require "rails_helper"

describe CustomEmailForm do
  let!(:admin) { create :admin }

  it "sends email to myself" do
    form = CustomEmailForm.new(user: admin, scope: "myself", message: "message", subject: "subject")
    expect(form.users).to eq([admin])
  end

  it "sends email to users with qae_opt_in_group" do
    user_1 = create(:user, subscribed_to_emails: true, email: "1@example.com")
    user_2 = create(:user, subscribed_to_emails: false, email: "2@example.com")
    user_3 = create(:user, subscribed_to_emails: true, email: "3@example.com")

    form = CustomEmailForm.new(user: admin,
                               scope: "qae_opt_in_group",
                               message: "message",
                               subject: "subject")

    expect(form.users).to eq([user_1, user_3])
  end

  it "sends email to users with bis_opt_in" do
    user_1 = create(:user, agree_being_contacted_by_department_of_business: true, email: "1@example.com")
    user_2 = create(:user, agree_being_contacted_by_department_of_business: false, email: "2@example.com")
    user_3 = create(:user, agree_being_contacted_by_department_of_business: true, email: "3@example.com")

    form = CustomEmailForm.new(user: admin,
                               scope: "bis_opt_in",
                               message: "message",
                               subject: "subject")

    expect(form.users).to eq([user_1, user_3])
  end

  it "sends email to all assessors" do
    user_1 = create(:assessor, email: "1@example.com")
    user_2 = create(:assessor, email: "2@example.com")
    user_3 = create(:assessor, email: "3@example.com")

    form = CustomEmailForm.new(user: admin,
                               scope: "assessors",
                               message: "message",
                               subject: "subject")

    expect(form.users).to eq([user_1, user_2, user_3])
  end

  it "sends email to all users" do
    user_1 = create(:user, email: "1@example.com")
    user_2 = create(:user, email: "2@example.com")
    user_3 = create(:user, email: "3@example.com")

    form = CustomEmailForm.new(user: admin,
                               scope: "all_users",
                               message: "message",
                               subject: "subject")

    expect(form.users).to eq([user_1, user_2, user_3])
  end
end
