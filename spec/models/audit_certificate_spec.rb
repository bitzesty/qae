require 'rails_helper'

RSpec.describe AuditCertificate, type: :model do
  describe "associations" do
    it { should belong_to(:form_answer) }
  end

  describe "validations" do
    %w(form_answer_id attachment).each do |field_name|
      it { should validate_presence_of field_name }
    end

    describe "Form answer should have just one Audit Certificate" do
      let!(:form_answer) { FactoryGirl.create(:form_answer) }
      let!(:audit_certificate) { FactoryGirl.create(:audit_certificate, form_answer: form_answer) }

      subject { FactoryGirl.build(:audit_certificate, form_answer: form_answer) }
      it {
        should validate_uniqueness_of(:form_answer_id)
      }
    end
  end
end
