require "rails_helper"

describe CustomEmailForm do
  let!(:admin) { create :admin }

  it "sends email to myself" do
    form = CustomEmailForm.new(user: admin, scope: "myself", message: "message", subject: "subject")
    expect(form.emails).to eq([admin.email])
  end

  it "sends email to users with qae_opt_in_group" do
    user_1 = create(:user, subscribed_to_emails: true)
    user_2 = create(:user, subscribed_to_emails: false)
    user_3 = create(:user, subscribed_to_emails: true)

    form = CustomEmailForm.new(user: admin, scope: "qae_opt_in_group", message: "message", subject: "subject")
    expect(form.emails).to eq([user_1.email, user_3.email])
  end

  it "sends email to users with bis_opt_in" do
    user_1 = create(:user, agree_being_contacted_by_department_of_business: true)
    user_2 = create(:user, agree_being_contacted_by_department_of_business: false)
    user_3 = create(:user, agree_being_contacted_by_department_of_business: true)

    form = CustomEmailForm.new(user: admin, scope: "bis_opt_in", message: "message", subject: "subject")
    expect(form.emails).to eq([user_1.email, user_3.email])
  end

  it "sends email to all assessors" do
    user_1 = create(:assessor)
    user_2 = create(:assessor)
    user_3 = create(:assessor)

    form = CustomEmailForm.new(user: admin, scope: "assessors", message: "message", subject: "subject")
    expect(form.emails).to eq([user_1.email, user_2.email, user_3.email])
  end

  it "sends email to all users" do
    user_1 = create(:user)
    user_2 = create(:user)
    user_3 = create(:user)

    form = CustomEmailForm.new(user: admin, scope: "all_users", message: "message", subject: "subject")
    expect(form.emails).to eq([user_1.email, user_2.email, user_3.email])
  end
end
