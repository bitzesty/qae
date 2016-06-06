require 'rails_helper'

shared_context "download original pdf before deadline ends" do
  let!(:form_answer) do
    f = create(:form_answer, :trade, :submitted)
    f.document["corp_responsibility_form"] = "declare_now"
    f.save!

    f
  end

  let!(:deadline) do
    Settings.current_submission_deadline
  end


  describe "Download" do
    before do
      deadline.trigger_at = Time.zone.now - 1.day
      deadline.save!
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
        expect(pdf_content).to include(registration_number_at_the_deadline)
        expect(pdf_content).to_not include(registration_number_after_deadline)
      end
    end
  end
end
