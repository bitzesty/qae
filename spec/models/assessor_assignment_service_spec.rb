require "rails_helper"

describe AssessorAssignmentService do
  let(:form_answer) { create(:form_answer, :trade) }
  let(:primary) { form_answer.assessor_assignments.primary }
  let!(:assessor) { create(:assessor, :lead_for_all) }

  before do
    st = allow_any_instance_of(described_class).to receive(:update_params)
    st.and_return(params[:assessor_assignment])
  end

  subject { described_class.new(params, assessor) }

  # assigning the assessor to specific case
  context "assessors assignment request" do
    let(:params) do
      {
        assessor_assignment: {
          form_answer_id: form_answer.id,
          position: 0
        },
        id: primary.id
      }.with_indifferent_access
    end

    it "does not assign the assessed_at date" do
      subject.save
      expect(subject.resource.assessed_at).to be_blank
    end

    context "regular assessor" do
      before do
        allow(assessor).to receive(:lead?).and_return(false)
      end

      it "can not change the assigned assessor"do
        expect(subject.permitted_params).to_not include(:assessor_id)
      end
    end

    context "lead assessor" do
      before do
        allow(assessor).to receive(:lead?).and_return(true)
      end

      it "changes the assigned assessor" do
        expect(subject.permitted_params).to include(:assessor_id)
      end
    end
  end

  # adding assessment to the case
  context "assessment request" do
    let(:params) do
      {
        assessor_assignment: {
          commercial_success_desc: "",
          verdict_desc: "this is a verdict"

        },
        id: primary.id
      }.with_indifferent_access
    end

    it "removes the keys with blank value" do
      expect(subject.update_params[:commercial_success_desc]).to be_blank
    end

    it "sets the assessed_at" do
      subject.save
      expect(subject.resource.assessed_at).to be_present
    end

    it "stores the assessment data in db" do
      subject.save
      expect(subject.resource.reload.verdict_desc).to eq("this is a verdict")
    end
  end
end
