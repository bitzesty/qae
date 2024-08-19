require "rails_helper"

Warden.test_mode!

describe "Assessment flow", %(
  As Assessor
  I want to participate in assessment flow.
), js: true do
  let!(:form_answer) { create(:form_answer, :innovation) }
  let!(:lead) { create(:assessor, :lead_for_all) }
  let!(:primary) { create(:assessor, :regular_for_innovation) }
  let(:text) { "textextextt" }

  before do
    p = form_answer.assessor_assignments.primary
    p.assessor = primary
    p.save
  end

  # TODO: need to rewrite this spec in accordance with latest flow changes

  #  it "follows the appropriate assessment flow" do
  #    login_as(lead, scope: :assessor)
  #    visit assessor_form_answer_path(form_answer)
  #    expect(page).to_not have_selector("#case-summary-heading")
  #    login_as(primary, scope: :assessor)
  #    visit assessor_form_answer_path(form_answer)
  #    expect(page).to_not have_selector("#case-summary-heading")
  #    expect(page).to_not have_selector("#appraisal-form-moderated-heading")
  #    login_as(lead, scope: :assessor)
  #    visit assessor_form_answer_path(form_answer)

  #    find("#appraisal-form-moderated-heading .panel-title a").click
  #    within "#section-appraisal-form-moderated" do
  #      all(".btn-rag").each do |rag|
  #        rag.click
  #        find(".dropdown-menu .rag-positive").click
  #      end

  #      all(".form-edit-link").each(&:click)

  #      all("textarea").each do |textarea|
  #        textarea.set text
  #      end

  #      all(".form-save-link").each(&:click)
  #      click_button "Submit appraisal"
  #    end

  #    visit assessor_form_answer_path(form_answer)
  #    expect(page).to_not have_selector("#case-summary-heading")
  #    login_as(primary, scope: :assessor)
  #    visit assessor_form_answer_path(form_answer)

  #    page.document.synchronize do
  #      element = first("#case-summary-heading-primary_case_summary .panel-title a")
  #      element.click if element
  #    end

  #    page.document.synchronize do
  #      within "#section-case-summary-primary_case_summary" do
  #        expect(page).to have_selector(".form-value p", text: text, count: 4)
  #        expect(page).to have_selector(".rag-text", text: "Green", count: 3)
  #        expect(page).to have_selector("input[value='Confirm case summary']")
  #        first(".btn-rag").click
  #        find(".dropdown-menu .rag-negative").click
  #      end
  #    end

  #    wait_for_ajax
  #    submit_primary_case_summary

  #    visit assessor_form_answer_path(form_answer)
  #    find("#case-summary-heading-primary_case_summary .panel-title a").click

  #    expect(page).to_not have_selector("input[value='Confirm case summary']")
  #    login_as(lead, scope: :assessor)
  #    visit assessor_form_answer_path(form_answer)
  #    find("#case-summary-heading-primary_case_summary .panel-title a").click

  #    page.document.synchronize do
  #      if first("#section-case-summary")

  #        within "#section-case-summary" do
  #          expect(page).to have_selector(".form-value p", text: text, count: 4)
  #          expect(page).to have_selector(".rag-text", text: "Green", count: 2)
  #          expect(page).to have_selector(".rag-text", text: "Red", count: 1)
  #          expect(page).to have_selector("input[value='Confirm case summary']")
  #        end
  #      end
  #    end
  #  end
  # end

  # def submit_primary_case_summary
  #  assessment = form_answer.assessor_assignments.primary_case_summary
  #  service = AssessmentSubmissionService.new(assessment, primary)
  #  service.perform
  # end

  # Needs to test the flow properly
  # Primary assessor submits appraisal form
  # Secondary assessor submits appraisal form
  # Lead assessor submits moderated form
  # Primary & Lead can edit the background on the Case summary (the rest is read only from primary assessor form and the overal verdict from moderated)
end
