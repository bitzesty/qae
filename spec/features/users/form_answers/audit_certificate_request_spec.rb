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
      document: generate(:financial_data_sample)
  end

  before do
    login_as user
  end

  describe "Visit Audit Certificate details page" do
    before do
      visit users_form_answer_audit_certificate_url(form_answer)
    end

    it "should render page" do
      expect_to_see "Audit Certificate"
      expect(page).to have_link(
        "this audit certificate",
        href: users_form_answer_audit_certificate_url(form_answer, format: :pdf)
      )
    end
  end

  describe "Download Audit Certificate prefilled with my financial data" do
    let(:audit_certificate_filename) do
      "audit_certificate_#{form_answer.decorate.pdf_filename}"
    end

    before do
      visit users_form_answer_audit_certificate_url(form_answer, format: :pdf)
    end

    it "should generate pdf file" do
      expect(page.status_code).to eq(200)
      expect(page.response_headers["Content-Disposition"]).to be_eql(
        "attachment; filename=\"#{audit_certificate_filename}\""
      )
      expect(page.response_headers["Content-Type"]).to be_eql "application/pdf"
    end
  end
end
