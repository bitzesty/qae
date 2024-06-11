require "rails_helper"

describe "Form answer attachments management", '
  As Admin
  I want to see be able to view/create the attachments per application.
' do
  let!(:admin) { create(:admin) }
  let!(:form_answer) { create(:form_answer) }

  before do
    login_admin admin
    visit admin_form_answer_path(form_answer)
  end

  it "adds the attachment" do
    within "#new_form_answer_attachment" do
      attach_file "form_answer_attachment_file", Rails.root.join("spec/fixtures/cat.jpg")
      find("input[type='submit']").click
    end
    expect(page).to have_selector(".form_answer_attachment", count: 1)
  end

  context "with existing attachment" do
    before do
      form_answer.form_answer_attachments.create!(
        file: Rack::Test::UploadedFile.new(
          Rails.root.join("spec/support/file_samples/photo_with_size_less_than_5MB.jpg"),
        ),
        attachable: admin,
        file_scan_results: "clean",
      )
      visit admin_form_answer_path(form_answer)
    end

    it "destroys the attachment" do
      click_button "Remove"
      expect(page).to have_content("No other documents")
    end
  end

  describe "Only admin can view this document option" do
    let(:assessor) { create(:assessor, :lead_for_all) }
    let(:form_answer) { create(:form_answer_attachment, :restricted_to_admin).form_answer }

    it "displays the attachment only for the admin" do
      login_as(assessor, scope: :assessor)
      visit admin_form_answer_path(form_answer)
      expect(page).to have_selector(".form_answer_attachment", count: 0)
    end
  end
end
