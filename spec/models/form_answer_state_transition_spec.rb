require "rails_helper"

describe FormAnswerStateTransition do
  let(:form_answer) { create(:form_answer, :trade, :submitted, state: :recommended) }

  describe "#collection" do
    before do
      subject.form_answer = form_answer

      allow(Settings).to receive(:after_current_submission_deadline?).and_return(true)
    end

    it "returns all states for admin" do
      admin = create(:admin)

      subject.subject = admin

      expected = [
        :assessment_in_progress,
        :recommended,
        :reserved,
        :not_recommended,
        :disqualified,
        :awarded,
        :not_awarded,
        :withdrawn,
      ]

      expect(subject.collection).to eq(expected)
    end

    it "excludes 'not awarded' and 'withdrawn' state for lead assessor" do
      assessor = create(:assessor, :lead_for_trade)

      subject.subject = assessor

      expected = [
        :assessment_in_progress,
        :recommended,
        :reserved,
        :not_recommended,
        :disqualified,
        :awarded,
      ]

      expect(subject.collection).to eq(expected)
    end
  end
end
