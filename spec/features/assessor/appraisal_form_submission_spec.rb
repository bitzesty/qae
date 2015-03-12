require "rails_helper"
include Warden::Test::Helpers

Warden.test_mode!

describe "Assessor submits appraisal form", %(
  As Assessor
  I want to be able to edit, submit the appraisal form.
), js: true do
  let!(:lead) { create(:assessor, :lead_for_all) }
  let!(:form_answer) { create(:form_answer, :innovation) }
  let(:primary) { "#section-appraisal-form-primary" }
  let(:secondary) { "#section-appraisal-form-secondary" }
  let(:moderated) { "#section-appraisal-form-moderated" }
  let(:primary_header) { "#appraisal-form-primary-heading" }
  let(:secondary_header) { "#appraisal-form-secondary-heading" }
  let(:moderated_header) { "#appraisal-form-moderated-heading" }

  before do
    login_as(lead, scope: :assessor)
    visit assessor_form_answer_path(form_answer)
  end

  describe "RAG change" do
    let(:rag_case) do
      lambda do |section_id, header_id|
        rag = ".rag-text"

        find("#{header_id} .panel-title a").click

        within section_id do
          expect(page).to have_selector(rag, text: "Select RAG", count: 3)
          expect(page).to have_selector(rag, text: "Select verdict", count: 1)

          first(".btn-rag").click
          find(".dropdown-menu .rag-negative").click

          expect(page).to have_selector(rag, text: "Select RAG", count: 2)
          expect(page).to have_selector(rag, text: "Red", count: 1)
          expect(page).to have_selector(rag, text: "Select verdict", count: 1)
        end

        sleep(0.5)
        visit assessor_form_answer_path(form_answer)

        find("#{header_id} .panel-title a").click

        within section_id do
          expect(page).to have_selector(rag, text: "Select RAG", count: 2)
          expect(page).to have_selector(rag, text: "Red", count: 1)
          expect(page).to have_selector(rag, text: "Select verdict", count: 1)
        end
      end
    end

    it "updates the rag rate" do
      rag_case.call(primary, primary_header)
      visit assessor_form_answer_path(form_answer)
      rag_case.call(secondary, secondary_header)
      visit assessor_form_answer_path(form_answer)
      rag_case.call(moderated, moderated_header)
    end
  end

  describe "Description change" do
    let(:text) { "textareatext123" }

    let(:description_case) do
      lambda do |section_id, header_id|
        find("#{header_id} .panel-title a").click

        within section_id do
          first(".form-edit-link").click
          expect(page).to have_selector("textarea", count: 1)
          fill_in("assessor_assignment_level_of_innovation_desc", with: text)
          find(".form-save-link").click
        end

        sleep(0.5)
        visit assessor_form_answer_path(form_answer)

        find("#{header_id} .panel-title a").click

        within section_id do
          expect(page).to have_selector(".form-value p", text: text, count: 1)
          first(".form-edit-link").click
          expect(page).to have_selector("textarea", text: text)
        end
      end
    end

    it "updates the description" do
      description_case.call(primary, primary_header)
      visit assessor_form_answer_path(form_answer)
      description_case.call(secondary, secondary_header)
      visit assessor_form_answer_path(form_answer)
      description_case.call(moderated, moderated_header)
    end
  end

  describe "Overall verdict change" do
    let(:verdict_case) do
      lambda do |section_id, header_id|
        find("#{header_id} .panel-title a").click

        within section_id do
          expect(page).to have_selector(".rag-text", text: "Select verdict", count: 1)
          all(".btn-rag").last.click
          find(".dropdown-menu .rag-positive").click
        end

        sleep(0.5)
        visit assessor_form_answer_path(form_answer)
        page.find("#{header_id} .panel-title a").click

        within section_id do
          expect(page).to_not have_selector(".rag-text", text: "Select verdict")
          expect(page).to have_selector(".rag-text", text: "Recommended", count: 1)
        end
      end
    end

    it "updates verdict" do
      verdict_case.call(primary, primary_header)
      visit assessor_form_answer_path(form_answer)
      verdict_case.call(secondary, secondary_header)
      visit assessor_form_answer_path(form_answer)
      verdict_case.call(moderated, moderated_header)
    end
  end

  it "submits the form" do
    allow_any_instance_of(AssessorAssignment).to receive(:valid?).and_return(true)
    find("#{primary_header} .panel-title a").click

    within "#section-appraisal-form-primary" do
      click_button "Submit Case Assessment"
    end
    expect(page).to have_selector(".feedbackHolder", text: "Assessment Submitted")
    expect(form_answer.assessor_assignments.primary).to be_submitted
  end
end
