require "rails_helper"
include Warden::Test::Helpers

describe "Admin comments management", %(
As a Admin
I want to be able to view, create and destroy the comments per application.
) do
  let!(:admin) { create(:admin) }
  let!(:form_answer) { create(:form_answer) }

  let(:admin_comments) { "#section-admin-comments" }
  let(:critical_comments) { "#section-critical-comments" }

  before do
    login_admin(admin)
    visit admin_form_answer_path(form_answer)
  end

  it "adds the comment" do
    within admin_comments do
      populate_comment_form("admin")
      expect { click_button "Comment" }.to change { Comment.count }.by(1)
    end
  end

  it "deletes the comment" do
    within admin_comments do
      populate_comment_form("admin")
      click_button "Comment"
    end

    expect{
      first(".link-delete-comment-confirm").click
    }.to change{ Comment.count }.by(-1)
  end

  it "displays the comments" do
    within admin_comments do
      populate_comment_form("admin")
      click_button "Comment"
      visit admin_form_answer_path(form_answer)
    end
    expect(page).to have_css(".comment-content", text: "body")
  end

  describe "adding flags", js: true do
    context "Admin comments" do
      it "adds flag to created comment" do
        first("#admin-comments-heading a").click

        within admin_comments do
          populate_comment_form("admin")
          find(".js-link-flag-comment").click
          click_button "Comment"
          expect(page).to have_selector(".comment-flagged", count: 1)

          within ".comment" do
            find(".js-link-flag-comment").click # unclick flag
            wait_for_ajax
          end
        end

        visit admin_form_answer_path(form_answer)
        expect(page).to have_selector(".comment-flagged", count: 0)
      end
    end

    context "Critical comments" do
      it "adds flag to created comment" do
        first("#critical-comments-heading a").click

        within critical_comments do
          populate_comment_form("critical")
          find(".js-link-flag-comment").click
          click_button "Comment"

          wait_for_ajax
        end

        expect(page).to have_selector(".comment-flagged", count: 1)
      end
    end
  end

  private

  def populate_comment_form(prefix)
    fill_in("#{prefix}_comment_body", with: "body")
  end
end
# TODO: can be added as shared example per assessor
