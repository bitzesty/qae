require "rails_helper"

describe UserDashboardHelper do
  subject { Object.new.extend(described_class) }
  describe "#unsuccessful_collection" do
    context "before shortlisting deadline" do
      before do
        allow(Settings).to receive(:not_shortlisted_deadline).and_return(DateTime.now + 1.hour)
      end

      it "returns blank list" do
        out = subject.unsuccessful_collection([double(state: "application_in_progress")])
        expect(out).to be_blank
      end
    end

    context "after shortlisting deadline" do
      let(:forms) do
        [
          double(state: "not_recommended"),
          double(state: "not_awarded")
        ]
      end

      before do
        allow(Settings).to receive(:not_shortlisted_deadline).and_return(DateTime.now - 1.hour)
      end

      context "before awarding deadline" do
        before do
          allow(Settings).to receive(:not_awarded_deadline).and_return(DateTime.now + 1.hour)
        end

        it "returns only awards with not recommended status" do
          out = subject.unsuccessful_collection(forms)
          expect(out.size).to eq(1)
          expect(out.first).to eq(forms.first)
        end
      end

      context "after awarding deadline" do
        before do
          allow(Settings).to receive(:not_awarded_deadline).and_return(DateTime.now - 1.hour)
        end

        it "returns all unsuccessful awards" do
          out = subject.unsuccessful_collection(forms)
          expect(out).to eq(forms)
        end
      end
    end
  end
end
