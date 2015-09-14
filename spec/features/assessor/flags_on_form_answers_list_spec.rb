require "rails_helper"
include Warden::Test::Helpers

describe "assessor sees the proper number of flags and sort by it" do
  let!(:assessor) { create(:assessor, :lead_for_all) }
  let!(:form_answer) { create(:form_answer, assessor_importance_flag: true, state: 'assessment_in_progress') }

  before do
    login_as(assessor, scope: :assessor)
  end

  context "no comments" do
    before {
      visit assessor_form_answers_path
    }
    it "sees only the global flag indicator" do
      within ".applications-table" do
        expect(first(".flag-count").text).to eq("1")
      end
    end
  end

  context "with flagged comments" do
    let!(:comment) do
      create(:flagged_comment, :assessor, commentable: form_answer, authorable: assessor)
    end
    before {
      visit assessor_form_answers_path
    }

    it "sees sum of comment flags and global flag" do
      within ".applications-table" do
        expect(first(".comment-count").text).to eq("1")
        expect(first(".flag-count").text).to eq("1")
      end
    end
  end
end
