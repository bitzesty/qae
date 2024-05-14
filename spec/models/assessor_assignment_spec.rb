require "rails_helper"

describe AssessorAssignment do
  let(:form) { AppraisalForm }

  context "Trade award" do
    context "with Innovation fields present" do
      let(:attributes) do
        [:level_of_innovation, :extent_of_value_added, :impact_of_innovation]
      end

      it "is invalid" do
        attributes.each do |meth|
          obj = build_assignment_with(:trade, meth)
          expect(obj).to_not be_valid
          expect(obj.errors.attribute_names).to include(form.desc(meth).to_sym)
        end
      end
    end

    context "only with Trade fields present" do
      let(:attributes) do
        [
          :overseas_earnings_growth,
          :commercial_success,
          :strategy,
          :verdict,
        ]
      end

      it "is valid" do
        attributes.each do |meth|
          obj = build_assignment_with(:trade, meth)
          expect(obj).to be_valid
        end
      end
    end
  end

  context "Development award" do
    context "with Enterprise fields present" do
      let(:attributes) do
        [:nature_of_activities, :impact_achievement, :level_of_support]
      end

      it "is invalid" do
        attributes.each do |meth|
          obj = build_assignment_with(:development, meth)
          expect(obj).to_not be_valid
          expect(obj.errors.attribute_names).to include(form.desc(meth).to_sym)
        end
      end
    end
  end

  describe "rates" do
    context "rag section" do
      context "with not allowed value" do
        subject do
          build :assessor_assignment,
            :trade,
            commercial_success_rate: "invalid"
        end
        it "is invalid" do
          expect(subject).to_not be_valid
          expect(subject.errors.attribute_names).to include(:commercial_success_rate)
        end
      end
    end
    context "with allowed value" do
      subject do
        build :assessor_assignment,
          :trade,
          commercial_success_rate: "negative"
      end
      it "is valid" do
        expect(subject).to be_valid
      end
    end
  end

  describe "#visible_for?" do
    let(:assessor1) { create(:assessor, :regular_for_all) }
    let(:assessor2) { create(:assessor, :regular_for_all) }
    let(:form_answer) { create(:form_answer) }
    let(:primary) { form_answer.assessor_assignments.primary }
    let(:secondary) { form_answer.assessor_assignments.secondary }
    before do
      primary.assessor = assessor1
      secondary.assessor = assessor2
      primary.save
      secondary.save
    end

    context "both submitted" do
      before do
        allow_any_instance_of(described_class).to receive(:submitted?).and_return(true)
      end

      it "is visible to both assessors" do
        expect(primary.visible_for?(assessor1)).to eq(true)
        expect(primary.visible_for?(assessor2)).to eq(true)
        expect(secondary.visible_for?(assessor1)).to eq(true)
        expect(secondary.visible_for?(assessor2)).to eq(true)
      end
    end

    context "none submitted" do
      before do
        allow_any_instance_of(described_class).to receive(:valid?).and_return(false)
      end

      it "is visible only for assigned assessor" do
        expect(primary.visible_for?(assessor1)).to eq(true)
        expect(secondary.visible_for?(assessor2)).to eq(true)

        expect(primary.visible_for?(assessor2)).to eq(false)
        expect(secondary.visible_for?(assessor1)).to eq(false)
      end
    end

    context "for primary/secondary assessor" do
      let(:lead) { create(:assessor, :lead_for_all) }
      it "moderated form is not visible" do
        moderated = form_answer.assessor_assignments.moderated
        expect(moderated.visible_for?(assessor1)).to eq(false)
        expect(moderated.visible_for?(assessor2)).to eq(false)
        expect(moderated.visible_for?(lead)).to eq(true)
      end
    end

    context "for previous award year" do
      let(:previous_award_year) { AwardYear.for_year(AwardYear.current.year - 1).first_or_create }
      let(:lead) { create(:assessor, :lead_for_all) }

      it "moderated form is not visible" do
        form_answer.award_year = previous_award_year
        form_answer.save!

        moderated = form_answer.assessor_assignments.moderated
        expect(moderated.visible_for?(assessor1)).to eq(true)
        expect(moderated.visible_for?(assessor2)).to eq(true)
        expect(moderated.visible_for?(lead)).to eq(true)

        expect(primary.visible_for?(assessor1)).to eq(true)
        expect(primary.visible_for?(assessor2)).to eq(true)
        expect(primary.visible_for?(lead)).to eq(true)

        expect(secondary.visible_for?(assessor1)).to eq(true)
        expect(secondary.visible_for?(assessor2)).to eq(true)
        expect(secondary.visible_for?(lead)).to eq(true)
      end
    end
  end

  context "moderated assessment" do
    subject { build(:assessor_assignment_moderated) }
    it "can not have assigned assessor" do
      subject.assessor_id = 1
      expect(subject).to_not be_valid
      expect(subject.errors.map { |error| error.message }.join(", ")).to match("cannot be present for this")
    end
  end

  context "assessor change" do
    let(:form) { create(:form_answer, :trade) }
    context "for assigning the primary/secondary assessor per application" do
      it "changes the state of flag on application" do
        primary = form.assessor_assignments.primary
        secondary = form.assessor_assignments.secondary

        expect {
          primary.update(assessor_id: 1)
        }.to change {
          form.reload.primary_assessor_id
        }.from(nil).to(1)

        expect {
          secondary.update(assessor_id: 2)
        }.to change {
          form.reload.secondary_assessor_id
        }.from(nil).to(2)

        expect {
          secondary.update(assessor: nil)
        }.to change {
          form.reload.secondary_assessor_id
        }.from(2).to(nil)

        expect {
          primary.update(assessor: nil)
        }.to change {
          form.reload.primary_assessor_id
        }.from(1).to(nil)
      end
    end
  end

  describe "#locked?" do
    it "should return false" do
      expect((build :assessor_assignment, locked_at: nil).locked?).to be_falsey
    end
    it "should return true" do
      expect((build :assessor_assignment, locked_at: 1.minute.ago).locked?).to be_truthy
    end
  end

  describe "#as_json" do
    let(:form) { create(:form_answer, :trade) }

    it "should return error" do
      assessor_assignment = build :assessor_assignment, position: nil, form_answer: form
      assessor_assignment.valid?
      expect(assessor_assignment.as_json).to eq({ :error => ["Position is empty - it is a required field and an option should be selected from the following list"] })
    end

    it "should return empty json" do
      assessor_assignment = build :assessor_assignment, form_answer: form
      expect(assessor_assignment.as_json).to eq({})
    end
  end

  describe "#secondary_assessor_can_edit?" do
    let(:form) { create(:form_answer, :trade) }
    it "should return true" do
      secondary = form.assessor_assignments.secondary
      expect(secondary.send(:secondary_assessor_can_edit?, build(:admin))).to be_truthy
    end
  end

  describe "#assessor_assignment_to_category" do
    let(:form) { create(:form_answer, :trade) }
    let(:assessor1) { create(:assessor, :regular_for_all) }
    it "should return true" do
      allow_any_instance_of(Assessor).to receive(:assignable?) { false }
      secondary = form.assessor_assignments.secondary
      secondary.assessor = assessor1
      secondary.save
      expect(secondary.errors[:assessor_id].present?).to be_truthy
    end
  end
end

def build_assignment_with(award_type, meth)
  obj = build(:assessor_assignment, award_type)
  obj.public_send(:"#{form.desc(meth)}=", "123")
  obj
end
