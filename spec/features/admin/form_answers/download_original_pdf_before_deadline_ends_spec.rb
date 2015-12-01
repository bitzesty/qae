require 'rails_helper'
include Warden::Test::Helpers

describe "Admin: Download original pdf of application at the deadline", %q{
As an Admin
I want to download original PDF of application at the deadline
So that I can see original application data was at the deadline moment
} do

  let!(:admin) { create(:admin) }

  before do
    login_admin(admin)
  end

  let!(:form_answer) do
    f = create(:form_answer, :trade, :submitted)
    f.document["corp_responsibility_form"] = "declare_now"
    f.save!

    f
  end

  let!(:deadline) do
    Settings.current_submission_deadline
  end

  describe "Policies" do
    describe "Submission not ended" do
      before do
        deadline.trigger_at = DateTime.now + 1.day
        deadline.save!

        visit admin_form_answer_path(form_answer)
      end

      it "should do not display download button" do
        expect_to_see_no "Download original PDF before deadline"
      end
    end
  end

  describe "Download" do
    let(:pdf_url) do
      original_pdf_before_deadline_admin_form_answer_url(form_answer, format: :pdf)
    end

    before do
      deadline.trigger_at = DateTime.now - 1.day
      deadline.save!
    end

    describe "Button displaying" do
      before do
        visit admin_form_answer_path(form_answer)
      end

      it "should display download button" do
        expect(page).to have_link(
          "Download original PDF before deadline", pdf_url
        )
      end
    end

    describe "PDF generation" do
      let(:pdf_filename) do
        "original_pdf_before_deadline_#{form_answer.decorate.pdf_filename}"
      end

      before do
        visit pdf_url
      end

      it "should generate pdf file" do
        expect(page.status_code).to eq(200)
        expect(page.response_headers["Content-Disposition"]).to be_eql(
          "attachment; filename=\"#{pdf_filename}\""
        )
        expect(page.response_headers["Content-Type"]).to be_eql "application/pdf"
      end
    end

    describe "PDF content" do
      let(:registration_number_at_the_deadline) {
        "1111111111".upcase
      }

      let(:registration_number_after_deadline) {
        "2222222222".upcase
      }

      let(:original_form_answer) do
        form_answer.original_form_answer
      end

      let(:pdf_generator) do
        original_form_answer.decorate.pdf_generator
      end

      let(:pdf_content) do
        PDF::Inspector::Text.analyze(pdf_generator.render).strings
      end

      before do
        # Turn onn Papertrail
        PaperTrail.enabled = true

        # Set current time to date before deadline
        Timecop.freeze(DateTime.now - 2.days) do
          form_answer.reload
          form_answer.document["registration_number"] = registration_number_at_the_deadline
          form_answer.save!
        end

        # Update value after deadline
        form_answer.reload
        form_answer.document["registration_number"] = registration_number_after_deadline
        form_answer.save!

        # Turn off Papertrail
        PaperTrail.enabled = false
      end

      it "should include main header information" do
        expect(pdf_content).to include(registration_number_at_the_deadline)
        expect(pdf_content).to_not include(registration_number_after_deadline)
      end
    end
  end
end
