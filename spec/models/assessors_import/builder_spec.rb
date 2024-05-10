require "rails_helper"

describe AssessorsImport::Builder do
  let(:csv_path) { File.join(Rails.root, "spec", "support", "file_samples", "emails.csv") }
  subject { AssessorsImport::Builder.new(csv_path) }

  describe "#initialize" do
    it "creates an instance with a valid filepath" do
      expect(subject).to be_a(AssessorsImport::Builder)
    end
  end

  describe "#process" do
    context "with emails not used by accessors" do
      it "creates new instances of Assessor based on the emails" do
        expect{ subject.process }.to change(Assessor, :count).by(subject.csv.count)
      end
    end

    context "save failed" do
     it "return not_saved" do
       allow_any_instance_of(Assessor).to receive(:save) { false }
       response = subject.process
       expect(response[:not_saved]).not_to be_empty
     end
   end

    context "with emails already used by accessors" do
      before do
        subject.process
      end

      it "does not create new Assessors for the giving emails" do
        subject.process
        expect{ subject.process }.not_to change(Assessor, :count)
      end
    end
  end
end
