require "rails_helper"

Warden.test_mode!

describe "Account forms" do
  let!(:award_year) { AwardYear.current }

  describe "Fill in first step form" do
    before do
      visit new_user_registration_path
    end

    it "does not create account when terms and conditions not accepted" do
      fill_in("Email", with: "test@example.com")
      fill_in("Password", with: "asldkj902lkads-0asd")
      fill_in("Password confirmation", with: "asldkj902lkads-0asd")

      click_button "Create account"
      expect(page).to have_content("Must be accepted")
    end

    it "creates the User account" do
      fill_in("Email", with: "test@example.com")
      fill_in("Password", with: "asldkj902lkads-0asd")
      fill_in("Password confirmation", with: "asldkj902lkads-0asd")

      find("input[type='checkbox']").set(true)

      click_button "Create account"
      expect(page).to have_content("We have just sent you an email asking to confirm your account")
    end
  end

  context "Account details fulfillment" do
    def fill_in_and_submit_account_details_form
      fill_in("Title", with: "Mr")
      fill_in("First name", with: "FirstName")
      fill_in("Last name", with: "LastName")
      fill_in("Your job title", with: "job title")
      fill_in("Your telephone number", with: phone_number)

      click_button("Save and continue")
    end

    context "regular user" do
      let!(:user) { create(:user, role: "regular") }

      before do
        create(:settings, :submission_deadlines)
        login_as(user, scope: :user)
        visit root_path
        fill_in_and_submit_account_details_form
      end

      let(:phone_number) { "020 4551 0081" }
      let(:company_name) { "BitZestyOrg" }

      it "adds the Account details" do
        expect(page).to have_content("Contact preferences")
        click_button("Save and continue")

        expect(page).to have_content("To begin your application, select the award(s) you want to apply for.")

        user.reload

        expect(user.phone_number).to eq(phone_number)
        expect(user.completed_registration?).to eq(true)
      end

      context "with an invalid phone number" do
        let(:phone_number) { "020 4551 008" }

        it "displays an error message" do
          expect(page).to have_content(
            I18n.t("activerecord.errors.models.user.attributes.phone_number.invalid"),
          )
        end
      end
    end

    context "admin user" do
      let!(:user) { create(:user, role: "account_admin") }

      before do
        create(:settings, :submission_deadlines)
        login_as(user, scope: :user)
        visit root_path
        fill_in_and_submit_account_details_form
      end

      let(:phone_number) { "020 4551 0081" }
      let(:company_name) { "BitZestyOrg" }

      it "adds the Account details" do
        expect(page).to have_content("Contact preferences")
        click_button("Save and continue")

        expect(page).to have_content("Organisation details")
        fill_in("Name of the organisation", with: company_name)
        fill_in("The organisation's main telephone number", with: "020 4551 0082")

        click_button("Save and continue")

        expect(page).to have_content("Collaborators and account owner")

        user.reload

        expect(user.phone_number).to eq(phone_number)
        expect(user.company_name).to eq(company_name)
      end

      context "with an invalid phone number" do
        let(:phone_number) { "020 4551 008" }

        it "displays an error message" do
          expect(page).to have_content(
            I18n.t("activerecord.errors.models.user.attributes.phone_number.invalid"),
          )
        end
      end
    end
  end
end
