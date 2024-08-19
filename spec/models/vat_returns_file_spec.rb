require "rails_helper"

RSpec.describe VatReturnsFile, type: :model do
  let(:sdw) { create(:shortlisted_documents_wrapper) }

  before do
    create(:vat_returns_file, shortlisted_documents_wrapper: sdw)
    sdw.update_column(:submitted_at, Time.zone.now)
  end

  describe "#destroy" do
    context "when it's not the only file" do
      it "does not unsubmit the form" do
        create(:vat_returns_file, shortlisted_documents_wrapper: sdw)
        sdw.vat_returns_files.last.destroy

        expect(sdw.reload).to be_submitted
      end
    end

    context "when it's the only file" do
      it "does unsubmit the form" do
        sdw.vat_returns_files.last.destroy
        expect(sdw.reload).not_to be_submitted
      end
    end
  end
end
