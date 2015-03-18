require "rails_helper"
include Warden::Test::Helpers

Warden.test_mode!

describe "Assessor assigns assessors", %(
  As Assessor
  I want to be able to assign assessors..
) do

  let(:subject) { create(:assessor, :lead_for_all) }
  let!(:assessor1) { create(:assessor, :regular_for_trade, first_name: "first-name#{rand(100)}") }
  let!(:assessor2) { create(:assessor, :regular_for_trade, first_name: "first-name#{rand(100)}") }

  describe "Form submission" do
    let!(:form_answer) { create(:form_answer, :trade) }
    let!(:form_answer1) { create(:form_answer, :trade) }

    before do
      login_as(subject, scope: :assessor)
      visit assessor_form_answers_path
    end

    it "assigns the assessor as primary", js: true do
      find(".btn", text: "Bulk Assign Assessors").click

      within ".applications-table" do
        first(".form-answer-check").set(true)
      end
      open_primary_select

      all(".select2-results__options li")[3].click

      within ".bulk-assign-assessors-form" do
        click_button "Assign"
      end

      within ".applications-table" do
        within "tbody" do
          expect(first("tr").text).to include(assessor2.full_name)
        end
      end
    end

    it "assigns both assessors", js: true do
      find(".btn", text: "Bulk Assign Assessors").click
      within ".applications-table" do
        first(".form-answer-check").set(true)
      end
      open_primary_select
      all(".select2-results__options li")[2].click
      open_secondary_select
      all(".select2-results__options li")[3].click

      within ".bulk-assign-assessors-form" do
        click_button "Assign"
      end
      within ".applications-table" do
        within "tbody" do
          expect(first("tr").text).to include(assessor1.full_name)
          expect(first("tr").text).to include(assessor2.full_name)
        end
      end
    end
  end
end

def open_primary_select
  page.execute_script("$('#assessor_assignment_collection_primary_assessor_id').select2('open');")
end

def open_secondary_select
  page.execute_script("$('#assessor_assignment_collection_secondary_assessor_id').select2('open');")
end
