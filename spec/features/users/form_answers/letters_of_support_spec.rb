require "rails_helper"
include Warden::Test::Helpers

describe "Letters of Support" do
  let(:user) { create :user }
  let(:form_answer) { create :form_answer, :promotion, user: user }
  let!(:settings) { create :settings, :submission_deadlines }

  before do
    login_as user
    visit form_form_answer_supporters_path(form_answer)
  end

  it "should be able to create supporter" do
    click_link "+ Add another supporter"
    fill_in "First name", with: "Jack"
    fill_in "Last name", with: "Lee"
    fill_in "Relationship to nominee", with: "Brother"
    fill_in "Email", with: "supp@example.com"
    click_button "Send support request"

    expect(page).to have_content("supp@example.com")
  end

  describe "Support Letters" do
    it "should be able to upload support letter" do
      click_link "+ Add another support letter"

      fill_in "First name", with: "Jack"
      fill_in "Last name", with: "Lee"
      fill_in "Relationship to nominee", with: "Brother"
      attach_file "Attachment", Rails.root.join("spec/fixtures/cat.jpg")
      click_button "Submit letter of support"

      expect(page).to have_link("cat.jpg")
    end
  end
end
