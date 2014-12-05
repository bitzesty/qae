require 'spec_helper'
include Warden::Test::Helpers

describe "Download a pdf of the award form filled", %q{
As a User
I want to be able to download a pdf of the filled in form filled in with whatever I have entered so far 
So that I can review my progress or share the pdf with others
} do

  let!(:user) do
    FactoryGirl.create :user
  end

  before do
    login_as user
  end

  # TODO: uncomment me once QAE2014Forms.trade implemeted
  #
  # describe "International Trade Award" do
  #   let!(:trade_award_form_answer) do
  #     FactoryGirl.create :form_answer, :trade, 
  #       user: user, 
  #       document: { company_name: "Bitzesty" }
  #   end

  #   let(:pdf_filename) do
  #     trade_award_form_answer.decorate.pdf_filename
  #   end

  #   before do 
  #     visit international_trade_award_confirm_path
  #   end

  #   it "should generate pdf" do
  #     click_on "Download your International Trade Award application"

  #     expect(page.status_code).to eq(200)
  #     expect(page.response_headers["Content-Disposition"]).to be_eql "attachment; filename=\"#{pdf_filename}\""
  #     expect(page.response_headers["Content-Type"]).to be_eql "application/pdf"
  #   end
  # end

  describe "Innovation Award" do
    let!(:innovation_award_form_answer) do
      FactoryGirl.create :form_answer, :innovation, 
        user: user, 
        document: { company_name: "Bitzesty" }
    end

    let(:pdf_filename) do
      innovation_award_form_answer.decorate.pdf_filename
    end

    before do 
      visit innovation_award_confirm_path(id: innovation_award_form_answer.id)
    end

    it "should generate pdf" do
      click_on "Download your Innovation Award application"

      expect(page.status_code).to eq(200)
      expect(page.response_headers["Content-Disposition"]).to be_eql "attachment; filename=\"#{pdf_filename}\""
      expect(page.response_headers["Content-Type"]).to be_eql "application/pdf"
    end    
  end

  # TODO: uncomment me once QAE2014Forms.development will be implemented
  #
  # describe "Sustainable Development Award" do
  #   let!(:development_award_form_answer) do
  #     FactoryGirl.create :form_answer, :development, 
  #       user: user, 
  #       document: { company_name: "Bitzesty" }
  #   end

  #   let(:pdf_filename) do
  #     development_award_form_answer.decorate.pdf_filename
  #   end

  #   before do 
  #     visit sustainable_development_award_confirm_path
  #   end

  #   it "should generate pdf" do
  #     click_on "Download your Sustainable Development Award application"

  #     expect(page.status_code).to eq(200)
  #     expect(page.response_headers["Content-Disposition"]).to be_eql "attachment; filename=\"#{pdf_filename}\""
  #     expect(page.response_headers["Content-Type"]).to be_eql "application/pdf"
  #   end
  # end
end