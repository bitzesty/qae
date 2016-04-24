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

  it "filters by corp_responsibility missing" do
    admin = create(:admin)
    create(:form_answer)
    form2 = create(:form_answer, document: { "website_url" => "www.example.com" })

    expect(FormAnswer.count).to eq(2)
    res = described_class.new(scope, admin).filter_by_sub_status(scope, ["missing_corp_responsibility"])
    expect(res.size).to eq(1)
    expect(res).to include(form2)
  end

  context "assessment filters" do
    let(:assessor) { create(:assessor, :lead_for_all) }
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
  end
end
