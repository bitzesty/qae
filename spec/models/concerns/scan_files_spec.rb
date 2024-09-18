require "rails_helper"

RSpec.describe ScanFiles do
  let(:record) { create(:form_answer_attachment) }

  describe "callbacks" do
    describe "#set_scan_results_to_pending" do
      it "defines the method" do
        record.save

        expect(record.respond_to?(:set_scan_results_to_pending)).to be_truthy
      end

      it "calls the method and sets the scan results to pending" do
        expect(record).to receive(:set_scan_results_to_pending)

        record.save

        expect(record.reload.file_scan_results).to eq "pending"
      end
    end

    describe "#perform_virus_scan" do
      it "calls the method on create/update" do
        expect(record).to receive(:perform_virus_scan)

        record.update(attachable: create(:user))
      end

      it "enqueues a FileScanJob for each file attribute to scan" do
        expect(FileScanJob).to receive(:perform_later).with(
          {
            model: "FormAnswerAttachment",
            column: :file,
            id: record.id,
          }.to_json,
          "FormAnswerAttachment",
          record.id,
          :file,
        )

        record.update(attachable: create(:user))
      end
    end
  end

  describe ".scan_for_viruses" do
    it "defines methods for scanning and cleaning per given attribute" do
      # assumes [scan_for_viruses :file] stated in model
      expect(record.respond_to?(:scan_file!)).to be_truthy
      expect(record.respond_to?(:on_scan_file)).to be_truthy
      expect(record.respond_to?(:clean?)).to be_truthy
      expect(record.respond_to?(:pending_or_scanning?)).to be_truthy
      expect(record.respond_to?(:infected?)).to be_truthy
      expect(record.respond_to?(:set_scan_results_to_pending)).to be_truthy
    end
  end

  describe ".scan_[attr_name]" do
    context "when ENV['DISABLE_VIRUS_SCANNER'] == 'true'" do
      before do
        ENV["DISABLE_VIRUS_SCANNER"] = "true"
        allow(record).to receive(:move_to_clean_bucket)
      end

      after do
        ENV["DISABLE_VIRUS_SCANNER"] = "false"
      end

      it "updates [attr_name]_scan_results to clean" do
        record.scan_file!

        expect(record.reload.file_scan_results).to eq "clean"
      end

      it "calls the move_to_clean_bucket method" do
        expect(record).to receive(:move_to_clean_bucket).with(:file)

        record.scan_file!
      end
    end

    context "when ENV['DISABLE_VIRUS_SCANNER'] == 'false'" do
      it "enqueues a FileScanJob and updates [attr_name]_scan_results to scanning" do
        expect(FileScanJob).to receive(:perform_later).with(
          {
            model: "FormAnswerAttachment",
            column: :file,
            id: record.id,
          }.to_json,
          "FormAnswerAttachment",
          record.id,
          "file",
        )

        record.scan_file!

        expect(record.reload.file_scan_results).to eq "scanning"
      end
    end
  end
end
