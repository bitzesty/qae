require "rails_helper"

describe FormAnswerSearch do
  let(:admin) { create(:admin) }
  let(:scope) { FormAnswer.all }

  it "filters by missing RSVP details" do
    create(:form_answer)
    create(:form_answer)

    invite1 = create(:form_answer)
    invite1.create_palace_invite!

    invite2 = create(:form_answer)
    invite_with_rsvp = invite2.create_palace_invite!
    att = invite_with_rsvp.palace_attendees.build
    att.save(validate: false)

    expect(FormAnswer.count).to eq(4)
    expect(PalaceAttendee.count).to eq(1)
    expect(PalaceInvite.count).to eq(2)

    res = described_class.new(scope, admin).filter_by_sub_status(scope, ["missing_rsvp_details"])
    expect(res.size).to eq(3)
    expect(res).to_not include(invite2)
    res = described_class.new(scope, admin).filter_by_sub_status(scope, [])
    expect(res.size).to eq(4)
    expect(res).to include(invite2)
  end

  context "assessment filters" do
    let(:assessor) { create(:assessor, :lead_for_all) }
    let!(:award_year) { AwardYear.current }
    let(:form_answer) { create(:form_answer, :trade, :submitted) }

    before do
      create(:settings, :expired_submission_deadlines)
      form_answer.state_machine.perform_transition(:assessment_in_progress)
    end

    context "filter by primary assessment" do
      let(:assessment) { form_answer.assessor_assignments.primary }

      it "filters out if assessment is not present" do
        result = described_class.new(scope, admin).filter_by_sub_status(scope, ["primary_assessment_submitted"])

        expect(result.length).to be_zero
      end

      it "filters out if assessment is not submitted" do
        assessment

        result = described_class.new(scope, admin).filter_by_sub_status(scope, ["primary_assessment_submitted"])

        expect(result.length).to be_zero
      end

      it "shows application if assessment is submitted" do
        AssessmentSubmissionService.new(assessment, assessor).perform

        result = described_class.new(scope, admin).filter_by_sub_status(scope, ["primary_assessment_submitted"])

        expect(result.length).to be_zero
      end
    end

    context "filter by secondary assessment" do
      let(:assessment) { form_answer.assessor_assignments.secondary }

      it "filters out if assessment is not present" do
        result = described_class.new(scope, admin).filter_by_sub_status(scope, ["secondary_assessment_submitted"])

        expect(result.length).to be_zero
      end

      it "filters out if assessment is not submitted" do
        assessment

        result = described_class.new(scope, admin).filter_by_sub_status(scope, ["secondary_assessment_submitted"])

        expect(result.length).to be_zero
      end

      it "shows application if assessment is submitted" do
        AssessmentSubmissionService.new(assessment, assessor).perform

        result = described_class.new(scope, admin).filter_by_sub_status(scope, ["secondary_assessment_submitted"])

        expect(result.length).to be_zero
      end
    end

    context "shows assessments with different verdicts" do
      let(:primary_assessment) { form_answer.assessor_assignments.primary }
      let(:secondary_assessment) { form_answer.assessor_assignments.secondary }
      let(:assessment_document) do
        {
          verdict_desc: "4",
          strategy_desc: "4",
          strategy_rate: "average",
          commercial_success_desc: "2",
          commercial_success_rate: "average",
          overseas_earnings_growth_desc: "1",
          overseas_earnings_growth_rate: "average",
          corporate_social_responsibility_desc: "testcsr",
          corporate_social_responsibility_rate: "average",
        }
      end

      before do
        primary_assessment.document = assessment_document.merge({ verdict_rate: "average" })
        primary_assessment.submitted_at = Time.current
        secondary_assessment.document = assessment_document.merge({ verdict_rate: "positive" })
        secondary_assessment.submitted_at = Time.current

        primary_assessment.save!
        secondary_assessment.save!
      end

      it "shows applications with different verdicts" do
        result = described_class.new(scope, admin).filter_by_sub_status(scope, ["recommendation_disperancy"])
        expect(result.length).to eq(1)
      end

      it "filters out applications with same verdicts" do
        secondary_assessment.document = assessment_document.merge({ verdict_rate: "average" })
        secondary_assessment.save!

        result = described_class.new(scope, admin).filter_by_sub_status(scope, ["recommendation_disperancy"])
        expect(result.length).to be_zero
      end
    end
  end
end
