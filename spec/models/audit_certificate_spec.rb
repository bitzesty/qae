require 'rails_helper'

RSpec.describe AuditCertificate, type: :model do
  describe "associations" do
    it { should belong_to(:form_answer) }
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
end
