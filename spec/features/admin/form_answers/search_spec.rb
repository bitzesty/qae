require "rails_helper"

describe "Form answer search", "
  As Admin
  I want to search by applications using bunch of attributes." do
  let!(:admin) { create(:admin) }

  before do
    create(:form_answer)
    login_admin admin
    visit admin_form_answers_path
  end

  context "success searching" do
    context "by user name" do
      let!(:user) { create(:user, first_name: first_name) }
      let(:first_name) { "user-#{rand(100000)}" }
      let!(:form_answer) { create(:form_answer, user: user) }

      it "searchs for form answer with first name" do
        within ".search-input" do
          fill_in "search_query", with: first_name
          click_button :submit
        end

        within ".applications-table" do
          expect(page).to have_selector("td.td-title", count: 1)
        end
      end
    end

    context "by award type" do
      let!(:form_answer) { create(:form_answer, :development) }
      it "search for form answer by award fullname" do
        within ".search-input" do
          fill_in "search_query", with: "sustainable"
          click_button :submit
        end

        within ".applications-table" do
          expect(page).to have_selector("td.td-title", count: 1)
          expect(all("td")[2].text).to eq(FormAnswerDecorator::AWARD_TITLES["Sustainable Development"])
        end
      end
    end
  end
end
