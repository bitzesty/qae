require "rails_helper"

describe AssessorAssignment do
  let(:form) { Assessment::AppraisalForm }

  context "Trade award" do
    context "with Innovation fields present" do
      let(:attributes) do
        [:level_of_innovation, :extent_of_value_added, :impact_of_innovation]
      end

      it "is invalid" do
        attributes.each do |meth|
          obj = build_assignment_with(:trade, meth)
          expect(obj).to_not be_valid
          expect(obj.errors.keys).to include(form.desc(meth).to_sym)
        end
      end
    end

    context "only with Trade fields present" do
      let(:attributes) do
        [
          :overseas_earnings_growth,
          :commercial_success,
          :strategy,
          :verdict
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
          expect(obj.errors.keys).to include(form.desc(meth).to_sym)
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
          expect(subject.errors.keys).to include(:commercial_success_rate)
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

  describe "submitted_at immutability" do
    it "allows to set up submitted_at only once" do
      obj = build(:assessor_assignment)
      obj.submitted_at = DateTime.now
      obj.valid?
      expect(obj.errors).to_not include(:submitted_at)
      obj.save(validate: false)
      obj.submitted_at = DateTime.now - 1.day
      obj.valid?
      expect(obj.errors.keys).to include(:submitted_at)
    end
  end
end

def build_assignment_with(award_type, meth)
  obj = build(:assessor_assignment, award_type)
  obj.public_send("#{form.desc(meth)}=", "123")
  obj
end
