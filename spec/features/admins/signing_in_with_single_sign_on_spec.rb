require "rails_helper"

describe "Signing in with Single Sign on" do
  let(:provider) { :dbt_staff_sso }
  let(:uid) { "B0d$-Bu770N$" }

  context "when the admin existed prior to SSO" do
    let(:admin) { create(:admin) }

    context "with the same details" do
      before { stub_sso_request(email: admin.email, first_name: admin.first_name, last_name: admin.last_name, uid:, provider:) }

      it "signs the admin in and updates the SSO fields" do
        expect { login_admin(admin, stub_sso: false) }.not_to change { Admin.count }
        expect_admin_to_be_signed_in
        admin.reload
        expect(admin.sso_uid).to eq(uid)
        expect(admin.sso_provider).to eq(provider.to_s)
      end
    end

    context "when the first_name has changed" do
      let(:new_first_name) { "Bob" }

      before { stub_sso_request(email: admin.email, first_name: new_first_name, last_name: admin.last_name, uid:, provider:) }

      it "signs the admin in and updates the SSO fields" do
        expect { login_admin(admin, stub_sso: false) }.not_to change { Admin.count }
        expect_admin_to_be_signed_in
        admin.reload
        expect(admin.sso_uid).to eq(uid)
        expect(admin.sso_provider).to eq(provider.to_s)
        expect(admin.first_name).to eq(new_first_name)
      end
    end

    context "when the last_name has changed" do
      let(:new_last_name) { "Buttons" }

      before { stub_sso_request(email: admin.email, first_name: admin.first_name, last_name: new_last_name, uid:, provider:) }

      it "signs the admin in, updates the SSO fields and the last_name" do
        expect { login_admin(admin, stub_sso: false) }.not_to change { Admin.count }
        expect_admin_to_be_signed_in
        admin.reload
        expect(admin.sso_uid).to eq(uid)
        expect(admin.sso_provider).to eq(provider.to_s)
        expect(admin.last_name).to eq(new_last_name)
      end
    end
  end

  context "when the admin has previously signed in with SSO" do
    let(:admin) { create(:admin, sso_uid: uid, sso_provider: provider) }

    context "with the same details" do
      before { stub_sso_request(email: admin.email, first_name: admin.first_name, last_name: admin.last_name, uid: admin.sso_uid, provider: admin.sso_provider) }

      it "signs the admin in" do
        expect { login_admin(admin, stub_sso: false) }.not_to change { Admin.count }
        expect_admin_to_be_signed_in
      end
    end

    context "when the email has changed" do
      let(:new_email) { "bob@buttons.com" }

      before { stub_sso_request(email: new_email, first_name: admin.first_name, last_name: admin.last_name, uid: admin.sso_uid, provider: provider) }

      it "signs the admin in and updates the email" do
        expect { login_admin(admin, stub_sso: false) }.not_to change { Admin.count }
        expect_admin_to_be_signed_in
        admin.reload
        expect(admin.email).to eq(new_email)
      end
    end

    context "when the first_name has changed" do
      let(:new_first_name) { "Bob" }

      before { stub_sso_request(email: admin.email, first_name: new_first_name, last_name: admin.last_name, uid: admin.sso_uid, provider: provider) }

      it "signs the admin in and updates the first_name" do
        expect { login_admin(admin, stub_sso: false) }.not_to change { Admin.count }
        expect_admin_to_be_signed_in
        admin.reload
        expect(admin.first_name).to eq(new_first_name)
      end
    end

    context "when the last_name has changed" do
      let(:new_last_name) { "Buttons" }

      before { stub_sso_request(email: admin.email, first_name: admin.first_name, last_name: new_last_name, uid: admin.sso_uid, provider: provider) }

      it "signs the admin in and updates the last_name" do
        expect { login_admin(admin, stub_sso: false) }.not_to change { Admin.count }
        expect_admin_to_be_signed_in
        admin.reload
        expect(admin.last_name).to eq(new_last_name)
      end
    end
  end

  context "when the admin is using the platform for the first time" do
    let(:email) { "bob@buttons.com" }
    let(:first_name) { "Bob" }
    let(:last_name) { "Buttons" }

    before do
      stub_sso_request(email:, first_name:, last_name:, uid:, provider:)
      visit "/admins/sign_in"
    end

    it "signs the admin in and creates a new admin record" do
      expect { click_link "Sign in with Dbt Staff Sso" }.to change { Admin.count }.from(0).to(1)
      expect_admin_to_be_signed_in

      admin = Admin.last
      expect(admin.email).to eq(email)
      expect(admin.first_name).to eq(first_name)
      expect(admin.last_name).to eq(last_name)
      expect(admin.sso_uid).to eq(uid)
      expect(admin.sso_provider).to eq(provider.to_s)
    end
  end

  def expect_admin_to_be_signed_in
    expect(page).to have_content("Successfully authenticated from DBT Staff SSO account.")
    expect(page).to have_selector(:link_or_button, "Sign out")
  end
end
