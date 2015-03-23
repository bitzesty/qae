require 'rails_helper'
include Warden::Test::Helpers

describe 'Form answer attachments management', %q{
  As Admin
  I want to see be able to view/create the attachments per application.
} do

  let!(:admin){ create(:admin)}
  let!(:form_answer){ create(:form_answer)}

  before do
    login_admin admin
    visit admin_form_answer_path(form_answer)
  end

  it "adds the attachment" do
    within "#new_form_answer_attachment" do
      attach_file "form_answer_attachment_file", "#{Rails.root}/spec/fixtures/cat.jpg"
      find("input[type='submit']").click
    end
    expect(page).to have_selector(".form_answer_attachment", count: 1)
  end

  context "with existing attachment" do
    before do
      form_answer.form_answer_attachments.create
      visit admin_form_answer_path(form_answer)
    end

    it "destroys the attachment" do
      click_button "Remove"
      expect(page).to have_content("No documents")
    end
  end
end
