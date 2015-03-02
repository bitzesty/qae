require 'rails_helper'
include Warden::Test::Helpers

describe "Audit Certificate", %q{
As a User
I want to be able to download an Audit Certificate
So that I can check, complete it and then upload it to application
} do

  let!(:user) do
    create :user
  end

  let!(:form_answer) do
    create :form_answer, :innovation,
      user: user,
      urn: "QA0001/19T",
      document: { company_name: "Bitzesty" }
  end

  before do
    login_as user
  end

  describe "Visit Audit Certificate details page" do
    before do
      visit users_form_answer_audit_certificate_url(form_answer)
    end

    it "should render page" do
      expect_to_see "You need to download, check and complete an audit certificate!"
      expect_to_see form_answer.decorate.award_application_title
      expect(page).to have_link(
        "Review Audit Certificate",
        href: users_form_answer_audit_certificate_url(form_answer, format: :csv)
      )
    end
  end

  describe "Download Audit Certificate prefilled with my financial data" do
    let(:audit_certificate_filename) do
      "audit_certificate_#{form_answer.decorate.csv_filename}"
    end

    before do
      visit users_form_answer_audit_certificate_url(form_answer, format: :csv)
    end

    it "should generate csv file" do
      expect(page.status_code).to eq(200)
      expect(page.response_headers["Content-Disposition"]).to be_eql(
        "attachment; filename=\"#{audit_certificate_filename}\""
      )
      expect(page.response_headers["Content-Type"]).to be_eql "application/csv"
    end
  end

  describe "Upload completed Audit Certificate" do
    let(:sample_txt_file_path) {
      "#{Rails.root}/spec/support/file_samples/simple_txt_sample.txt"
    }

    describe "validations" do
      before do
        visit users_form_answer_audit_certificate_url(form_answer)
      end

      it "should display errors" do
        click_on "Upload"
        expect_to_see "This field cannot be blank"

        attach_file('audit_certificate_attachment', sample_txt_file_path)
        click_on "Upload"
        expect_to_see "You are not allowed to upload \"txt\" files, allowed types: csv"
      end
    end

    describe "proper uploading" do
      let(:sample_csv_file_path) {
        "#{Rails.root}/spec/support/file_samples/audit_certificate_sample.csv"
      }

      before do
        visit users_form_answer_audit_certificate_url(form_answer)
      end

      it "should upload proper file" do
        within("#new_audit_certificate") do
          attach_file('audit_certificate_attachment', sample_csv_file_path)
          click_on "Upload"
        end

        expect_to_see "Audit Certificate completed!"
        expect_to_see_no "You need to download, check and complete an audit certificate!"
      end
    end

    describe "Audit Certificate already completed" do
      let(:audit_certificate) {
        create(:audit_certificate, form_answer: form_answer)
      }

      before do
        audit_certificate
        visit users_form_answer_audit_certificate_url(form_answer)
      end

      it "should not allow to upload another certificate if it's already exists" do
        expect_to_see "Audit Certificate completed!"
        expect_to_see_no "You need to download, check and complete an audit certificate!"
      end
    end
  end
end
