require "rails_helper"

shared_context "download original pdf before deadline ends" do
  let!(:form_answer) do
    create(:form_answer, :trade, :submitted)
  end

  describe "Download" do
    describe "PDF content" do
      let(:registration_number_at_the_deadline) { "1111111111" }
      let(:registration_number_after_deadline) { "2222222222" }

      before do
        # Turn onn Papertrail
        PaperTrail.enabled = true

        # Set current time to date before deadline
        Timecop.freeze(Time.zone.now - 2.days) do
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
        original_form_answer = form_answer.original_form_answer
        pdf_generator = original_form_answer.decorate.pdf_generator
        pdf_content = PDF::Inspector::Text.analyze(pdf_generator.render).strings

        expect(pdf_content).to include(Settings.submission_deadline_title)
      end
    end
  end
end
