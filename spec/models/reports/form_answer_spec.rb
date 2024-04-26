require "rails_helper"

describe Reports::FormAnswer do
  describe "#employees" do
    it "returns number of employees" do
      obj = build(:form_answer, :trade)
      obj.document["employees_6of6"] = 10
      obj.document["trade_commercial_success"] = "6 plus"
      expect(described_class.new(obj).employees).to eq(10)
    end
  end

  describe '#call_method' do
    it 'should return missing method' do
      expect(Reports::FormAnswer.new(build(:form_answer, :trade)).call_method(:missing)).to eq 'missing method'
    end
  end

  describe "#press_contact_full_name" do
    it "returns press contact's full name" do
      form_answer = build(:form_answer, :trade)
      summary = double(name: "Rob", title: "Earl", last_name: "Stark")
      allow(form_answer).to receive(:press_summary).and_return(summary)

      expect(described_class.new(form_answer).press_contact_full_name).to eq("Earl Rob Stark")
    end

    it "returns cotact's full name taken from application if PS is not submitted" do
      form_answer = build(:form_answer, :trade)
      form_answer.document = form_answer.document.merge(
        press_contact_details_title: "Countess",
        press_contact_details_first_name: "Kathleen",
        press_contact_details_last_name: "Stark"
      )

      summary = double(name: "", title: "Earl", last_name: "Stark")
      allow(form_answer).to receive(:press_summary).and_return(summary)

      expect(described_class.new(form_answer).press_contact_full_name).to eq("Countess Kathleen Stark")
    end
  end

  describe 'user methods' do
    let(:user) do
      build(:user,
            company_address_first: "company_address_first",
            company_address_second: "company_address_second",
            company_city: "company_city",
            company_postcode: "company_postcode",
            phone_number: "phone_number",
            company_phone_number: "company_phone_number",
      )
    end
    let(:report) {Reports::FormAnswer.new(build(:form_answer, user: user))}

    it '#address_line1 should return address_line1' do
      expect(report.address_line1).to eq "company_address_first"
    end

    it '#address_line2 should return address_line2' do
      expect(report.address_line2).to eq "company_address_second"
    end

    it '#address_line3 should return address_line3' do
      expect(report.address_line3).to eq "company_city"
    end

    it '#postcode should return postcode' do
      expect(report.postcode).to eq "company_postcode"
    end

    it '#telephone1 should return telephone1' do
      expect(report.telephone1).to eq "phone_number"
    end

    it '#telephone2 should return telephone2' do
      expect(report.telephone2).to eq "company_phone_number"
    end
  end


  describe '#case_summary_status' do
    it 'should return correct status' do
      assessor_assignment = build(:assessor_assignment)
      allow_any_instance_of(Reports::FormAnswer).to receive(:pick_assignment) {assessor_assignment}
      allow_any_instance_of(AssessorAssignment).to receive(:submitted?) {true}
      allow_any_instance_of(AssessorAssignment).to receive(:locked?) {true}
      expect(Reports::FormAnswer.new(build(:form_answer, :trade)).send(:case_summary_status)).to eq 'Submitted'

      allow_any_instance_of(AssessorAssignment).to receive(:locked?) {false}
      expect(Reports::FormAnswer.new(build(:form_answer, :trade)).send(:case_summary_status)).to eq 'Not Submitted'
    end
  end

  describe '#mso_grade_agreed' do
    it 'should return correct grade' do
      allow_any_instance_of(Reports::FormAnswer).to receive(:pick_assignment) {build(:assessor_assignment_moderated)}
      allow_any_instance_of(Reports::FormAnswer).to receive(:pick_assignment).with('moderated') {build(:assessor_assignment_moderated, document: { w_rate_1: 'positive', w_rate_2: 'average', })}
      expect(Reports::FormAnswer.new(build(:form_answer)).send(:mso_grade_agreed)).to eq 'G,A'
    end
  end

  describe '#government_support' do
    it 'should return correct value' do
      inn_form_answer = build(:form_answer, :innovation)
      inn_form_answer.document = inn_form_answer.document.merge(
        innovations_grant_funding: "yes",
      )
      expect(Reports::FormAnswer.new(build(:form_answer, :trade)).send(:government_support)).to eq "No"
      expect(Reports::FormAnswer.new(inn_form_answer).send(:government_support)).to eq "Yes"
    end
  end
end
