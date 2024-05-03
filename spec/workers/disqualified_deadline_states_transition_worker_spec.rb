require "rails_helper"

RSpec.describe DisqualifiedDeadlineStatesTransitionWorker do
  it "should perform correctly" do
    expect(FormAnswerStateMachine).to receive(:trigger_audit_deadlines)
    described_class.new.perform
  end
end
