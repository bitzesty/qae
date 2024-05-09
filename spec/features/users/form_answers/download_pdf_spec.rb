require "rails_helper"
include Warden::Test::Helpers

describe "Download a pdf of the award form filled", %q{
As a User
I want to be able to download a pdf of the filled in form filled in with whatever I have entered so far
So that I can review my progress or share the pdf with others
} do
  let!(:user) do
    FactoryBot.create :user
  end

  before do
    login_as user
  end

  describe "International Trade Award" do
    let!(:trade_award_form_answer) do
      FactoryBot.create :form_answer, :trade,
        user: user,
        document: { company_name: "Bitzesty" }
    end

    let(:pdf_filename) do
      trade_award_form_answer.decorate.pdf_filename
    end

    before do
      visit users_form_answer_path(trade_award_form_answer, format: :pdf)
    end

    it "should generate pdf" do
      expect(page.status_code).to eq(200)
      expect(page.response_headers["Content-Disposition"]).to include "attachment; filename=\"#{pdf_filename}\""
      expect(page.response_headers["Content-Type"]).to be_eql "application/pdf"
    end
  end

  describe "Innovation Award" do
    let!(:innovation_award_form_answer) do
      FactoryBot.create :form_answer, :innovation,
        user: user,
        urn: "QA0001/19T",
        document: { company_name: "Bitzesty" }
    end

    let(:pdf_filename) do
      innovation_award_form_answer.decorate.pdf_filename
    end

    before do
      visit users_form_answer_path(innovation_award_form_answer, format: :pdf)
    end

    it "should generate pdf" do
      expect(page.status_code).to eq(200)
      expect(page.response_headers["Content-Disposition"]).to include "attachment; filename=\"#{pdf_filename}\""
      expect(page.response_headers["Content-Type"]).to be_eql "application/pdf"
    end
  end

  describe "Sustainable Development Award" do
    let!(:development_award_form_answer) do
      FactoryBot.create :form_answer, :development,
        user: user,
        document: { company_name: "Bitzesty" }
    end

    let(:pdf_filename) do
      development_award_form_answer.decorate.pdf_filename
    end

    before do
      visit users_form_answer_path(development_award_form_answer, format: :pdf)
    end

    it "should generate pdf" do
      expect(page.status_code).to eq(200)
      expect(page.response_headers["Content-Disposition"]).to include "attachment; filename=\"#{pdf_filename}\""
      expect(page.response_headers["Content-Type"]).to be_eql "application/pdf"
    end
  end
end
