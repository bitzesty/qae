require "rails_helper"

describe AssessorAssignmentDecorator do
  let(:editor) { User.new(first_name: "Foo", last_name: "Bar") }
  let(:assessor_assignment) { AssessorAssignment.new(editable: editor) }
  let(:subject) { assessor_assignment.decorate }

  describe "#last_editor_info" do
    context "not accessed" do
      it "returns false" do
        expect(subject.last_editor_info).to be_falsy
      end
    end

    context "with accessed_at value" do
      context "with an editor" do
        it "returns the editable name and accessed date on a string" do
          assessor_assignment.assessed_at = Time.now
          expect(subject.last_editor_info).to eq("Updated by #{editor.full_name} - #{I18n.l(assessor_assignment.assessed_at,
                                                                                            format: :date_at_time)}")
        end
      end

      context "without an editor name" do
        it "returns the editable as Anonymous and accessed date on a string" do
          assessor_assignment.assessed_at = Time.now
          assessor_assignment.editable = User.new
          expect(subject.last_editor_info).to eq("Updated by Anonymous - #{I18n.l(assessor_assignment.assessed_at,
                                                                                  format: :date_at_time)}")
        end
      end
    end
  end
end
