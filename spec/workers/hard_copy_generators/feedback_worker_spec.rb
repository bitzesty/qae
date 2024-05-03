require "rails_helper"

RSpec.describe HardCopyPdfGenerators::FeedbackWorker do
  it "should perform correctly" do
    form_answer = build_stubbed(:form_answer)
    expect(FormAnswer).to receive(:find).with(1) { form_answer }
    expect(form_answer).to receive(:generate_feedback_hard_copy_pdf!)
    described_class.new.perform(1)
  end
end
