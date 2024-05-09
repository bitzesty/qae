require "rails_helper"

RSpec.describe AuditCertificate, type: :model do
  describe "associations" do
    it { should belong_to(:form_answer).optional }
  end

  describe "validations" do
    %w(form_answer_id attachment).each do |field_name|
      it { should validate_presence_of field_name }
    end

    describe "Form answer should have just one Verification of Commercial Figures" do
      let!(:form_answer) { create(:form_answer) }
      let!(:audit_certificate) { create(:audit_certificate, form_answer: form_answer) }

      subject { build(:audit_certificate, form_answer: form_answer) }
      it {
        should validate_uniqueness_of(:form_answer_id)
      }
    end
  end

  describe "save" do
    it "should set changes_description" do
      audit_certificate = create(:audit_certificate, changes_description: "test")
      audit_certificate.update(status: "no_changes_necessary")
      expect(audit_certificate.changes_description).to be_nil
    end
  end
end
