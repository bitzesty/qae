require "rails_helper"

RSpec.describe HardCopyPdfGenerators::FormDataWorker do
  it "should perform correctly" do

    form_answer = build_stubbed(:form_answer)
    expect(FormAnswer).to receive(:find).with(1).twice { form_answer }

    expect(form_answer).to receive(:generate_pdf_version_from_latest_doc!)
    described_class.new.perform(1, true)

    expect(form_answer).to receive(:generate_pdf_version!)
    described_class.new.perform(1)
  end
end




