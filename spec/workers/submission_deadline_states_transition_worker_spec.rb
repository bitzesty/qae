require "rails_helper"

RSpec.describe SubmissionDeadlineStatesTransitionWorker do
  it "should perform correctly" do
    expect(FormAnswerStateMachine).to receive(:trigger_deadlines)
    described_class.new.perform
  end
end
