require "rails_helper"
include Warden::Test::Helpers

describe "Admin sees the proper number of flags and sort by it" do
  let!(:admin) { create(:admin) }
  let!(:form_answer) { create(:form_answer, admin_importance_flag: true) }

  before do
    login_admin(admin)
  end

  context "no comments" do
    before { visit admin_form_answers_path }
    it "sees only the global flag indicator" do
      within ".applications-table" do
        expect(first(".flag-count").text).to eq("1")
      end
    end
  end

  context "with flagged comments" do
    let!(:comment) do
      create(:flagged_comment, :admin, commentable: form_answer, authorable: admin)
    end
    before { visit admin_form_answers_path }

    it "sees sum of comment flags and global flag" do
      within ".applications-table" do
        expect(first(".flag-count").text).to eq("2")
      end
    end
  end
end
