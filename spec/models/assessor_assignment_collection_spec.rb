require "rails_helper"

describe AssessorAssignmentCollection do
  subject { described_class.new(params) }
  let(:form_answer) { create(:form_answer) }
  let!(:primary) { form_answer.assessor_assignments.primary }
  let!(:secondary) { form_answer.assessor_assignments.secondary }
  let(:assessor1) { create(:assessor, :regular_for_all) }
  let(:assessor2) { create(:assessor, :regular_for_all) }

  before { subject.subject = build(:assessor, :lead_for_all) }

  context "both assessors are the same" do
    let(:params) do
      {
        form_asnwer_ids: "1,2",
        primary_assessor_id: 1,
        secondary_assessor_id: 1
      }
    end

    it "does not validate the assignment" do
      expect(subject).to_not be_valid
    end
  end

  context "double assignment" do
    let(:params) do
      {
        form_answer_ids: form_answer.id.to_s,
        primary_assessor_id: assessor1.id,
        secondary_assessor_id: assessor2.id
      }
    end
    # primary/secondary are assigned at once
    context "new primary is old secondary" do
      it "assigns the new assessors" do
        secondary.assessor = assessor1
        secondary.save
        subject.save
        expect(primary.reload.assessor).to eq(assessor1)
        expect(secondary.reload.assessor).to eq(assessor2)
      end
    end

    context "new secondary is old primary" do
      it "assigns the new assessors" do
        primary.assessor = assessor2
        primary.save
        subject.save
        expect(primary.reload.assessor).to eq(assessor1)
        expect(secondary.reload.assessor).to eq(assessor2)
      end
    end
  end

  context "Not assigned" do
    let(:params) do
      {
        form_answer_ids: form_answer.id.to_s,
        primary_assessor_id: "not assigned",
        secondary_assessor_id: ""
      }
    end

    it "erases the assessor" do
      primary.assessor = assessor1
      primary.save
      subject.save
      expect(primary.reload.assessor).to be_nil
    end
  end

  context "Single assignment" do
    let(:params) do
      {
        form_answer_ids: form_answer.id.to_s,
        primary_assessor_id: assessor1.id.to_s
      }
    end

    it "assigns the assessor" do
      subject.save
      expect(primary.reload.assessor).to eq(assessor1)
    end
  end
  describe "#add_error" do
    let(:params) {}
    it "should set errors" do
      object =  AssessorAssignmentCollection.new
      object.send(:add_error, "test error")
      expect(object.assignment_errors).to eq(["test error"])
    end
  end
end
