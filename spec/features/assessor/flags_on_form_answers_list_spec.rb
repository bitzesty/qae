require "rails_helper"
include Warden::Test::Helpers

describe "assessor sees the proper number of flags and sort by it" do
  let!(:assessor) { create(:assessor, :lead_for_all) }
  let!(:form_answer) { create(:form_answer, state: 'assessment_in_progress') }

  before do
    login_as(assessor, scope: :assessor)
  end

  context "no comments" do
    before {
      visit assessor_form_answers_path
    }
    it "doesn't see counters" do
      within ".applications-table" do
        expect(first(".flag-count")).to be_nil
        expect(first(".comment-count")).to be_nil
      end
    end
  end

  context "with not flagged comment" do
    let!(:comment) do
      create(:comment, :assessor, commentable: form_answer, authorable: assessor)
    end
    before {
      visit assessor_form_answers_path
    }

    it "sees sum of comments" do
      within ".applications-table" do
        expect(first(".comment-count").text).to eq("1")
        expect(first(".flag-count")).to be_nil
      end
    end
  end

  context "with flagged comment" do
    let!(:comment) do
      create(:comment, :flagged, :assessor, commentable: form_answer, authorable: assessor)
    end
    before {
      visit assessor_form_answers_path
    }

    it "sees sum of comments and flagged comments" do
      within ".applications-table" do
        expect(first(".comment-count").text).to eq("1")
        expect(first(".flag-count").text).to eq("1")
      end
    end
  end
end
