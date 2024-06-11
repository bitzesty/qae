require "rails_helper"

Warden.test_mode!

describe "Assessor fulfills the draft notes.", js: true do
  let!(:form_answer) { create(:form_answer) }
  let!(:assessor) { create(:assessor, :lead_for_all) }

  before do
    login_as(assessor, scope: :assessor)
    visit assessor_form_answer_path form_answer
  end
  let(:text) { "textext" }

  it "fulfills the draft notes form" do
    find("#draft-notes-heading .panel-title a").click
    within "#section-draft-notes" do
      find("#draft_note_content").set(text)
      click_link "Save"
      wait_for_ajax
    end
    visit assessor_form_answer_path form_answer
    find("#draft-notes-heading .panel-title a").click
    expect(page).to have_content(text)
  end
end
