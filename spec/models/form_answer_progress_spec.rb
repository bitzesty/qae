require "rails_helper"

describe FormAnswerProgress do
  describe "#section" do
    context "No progress for section" do
      it "returns -" do
        expect(build(:form_answer_progress).section(1)).to eq("-")
      end
    end

    context "60% for 2nd section" do
      it "returns progress" do
        expect(build(:form_answer_progress, :second_60).section(2)).to eq("60%")
      end
    end
  end
end
