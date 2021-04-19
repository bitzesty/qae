require "rails_helper"

RSpec.describe ListOfProcedure, type: :model do
  describe "associations" do
    it { should belong_to(:form_answer) }
  end

  describe "validations" do
    %w[form_answer_id attachment].each do |field_name|
      it { should validate_presence_of field_name }
    end

    describe "Form answer should have just one list of procedure" do
      let!(:form_answer) { create(:form_answer) }
      let!(:list_of_procedure) { create(:list_of_procedure, form_answer: form_answer) }

      subject { build(:list_of_procedure, form_answer: form_answer) }
      it {
        should validate_uniqueness_of(:form_answer_id)
      }
    end
  end

  describe "save" do
    it "should set changes_description" do
      list_of_procedure = create(:list_of_procedure, changes_description: "test")
      list_of_procedure.update(status: "no_changes_necessary")
      expect(list_of_procedure.changes_description).to be_nil
    end
  end
end
