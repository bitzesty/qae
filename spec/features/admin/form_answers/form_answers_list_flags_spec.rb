require "rails_helper"

describe "Admin sees the proper number of flags and sort by it" do
  let!(:admin) { create(:admin) }
  let!(:form_answer) { create(:form_answer) }

  before do
    login_admin(admin)
  end

  context "no comments" do
    before { visit admin_form_answers_path }

    it "doesn't see counters" do
      within ".applications-table" do
        expect(page).not_to have_css(".flag-count")
        expect(page).not_to have_css(".comment-count")
      end
    end
  end

  context "with flagged comments" do
    let!(:comment) do
      create(:comment, :admin, commentable: form_answer, authorable: admin)
    end
    before { visit admin_form_answers_path }

    it "sees sum of comments" do
      within ".applications-table" do
        expect(page).not_to have_css(".flag-count")
        expect(page).to have_css(".comment-count", text: "1")
      end
    end
  end

  context "with flagged comments" do
    let!(:comment) do
      create(:comment, :flagged, :admin, commentable: form_answer, authorable: admin)
    end
    before { visit admin_form_answers_path }

    it "sees sum of comments and flagged comments" do
      within ".applications-table" do
        expect(page).to have_css(".flag-count", text: "1")
        expect(page).to have_css(".comment-count", text: "1")
      end
    end
  end
end
