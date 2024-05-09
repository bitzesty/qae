require "rails_helper"

RSpec.describe Scheduled::SubmissionDeadlineWorker do
  it "should perform correctly" do
    expect(FormAnswerStateMachine).to receive(:trigger_deadlines)
    described_class.new.perform
  end
end
