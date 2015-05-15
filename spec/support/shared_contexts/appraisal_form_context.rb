shared_context "successful appraisal form edition" do
  let!(:form_answer) { create(:form_answer, :innovation) }
  let(:primary) { "#section-appraisal-form-primary" }
  let(:secondary) { "#section-appraisal-form-secondary" }
  let(:moderated) { "#section-appraisal-form-moderated" }
  let(:primary_header) { "#appraisal-form-primary-heading" }
  let(:secondary_header) { "#appraisal-form-secondary-heading" }
  let(:moderated_header) { "#appraisal-form-moderated-heading" }

  before do
    login_as(subject, scope: scope)
    visit show_path
  end

  describe "Rag change" do
    it "updates the rag rate" do
      assert_rag_change(primary, primary_header)
      assert_rag_change(secondary, secondary_header)
      assert_rag_change(moderated, moderated_header)
    end
  end

  describe "Description change" do
    let(:text) { "textareatext123" }

    it "updates the description" do
      assert_description_change(primary, primary_header)
      assert_description_change(secondary, secondary_header)
      assert_description_change(moderated, moderated_header)
    end

    context "multiple descriptions change" do
      it "updates the form in separation" do
        assert_multiple_description_change(primary, primary_header)
        assert_multiple_description_change(secondary, secondary_header)
        assert_multiple_description_change(moderated, moderated_header)
      end
    end
  end

  describe "Overall verdict change" do
    it "updates verdict" do
      assert_verdict_change(primary, primary_header)
      assert_verdict_change(secondary, secondary_header)
      assert_verdict_change(moderated, moderated_header)
    end
  end
end

shared_context "successful case summary edition" do
  let(:case_summary_header) { "#case-summary-heading-lead_case_summary" }
  let(:case_summary) { "#section-case-summary-lead_case_summary" }
  let!(:form_answer) { create(:form_answer, :innovation) }
  let(:text) { "textareatext123123" }

  before do
    login_as(subject, scope: scope)
    visit show_path
  end

  it "updates verdict fields" do
    assert_verdict_change(case_summary, case_summary_header)
  end
  it "updates the rag fields" do
    assert_rag_change(case_summary, case_summary_header)
  end
end

def assert_rag_change(section_id, header_id)
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
  visit show_path

  find("#{header_id} .panel-title a").click

  within section_id do
    expect(page).to have_selector(rag, text: "Select RAG", count: 2)
    expect(page).to have_selector(rag, text: "Red", count: 1)
    expect(page).to have_selector(rag, text: "Select verdict", count: 1)
  end
  visit show_path
end

def assert_description_change(section_id, header_id)
  find("#{header_id} .panel-title a").click

  within section_id do
    first(".form-edit-link").click
    expect(page).to have_selector("textarea", count: 1)
    fill_in("assessor_assignment_level_of_innovation_desc", with: text)
    find(".form-save-link").click
  end

  sleep(0.5)
  visit show_path

  find("#{header_id} .panel-title a").click

  within section_id do
    expect(page).to have_selector(".form-value p", text: text, count: 1)
    first(".form-edit-link").click
    expect(page).to have_selector("textarea", text: text)
  end
  visit show_path
end

def assert_multiple_description_change(section_id, header_id)
  text = "should NOT be saved"
  text2 = "should be saved"

  find("#{header_id} .panel-title a").click
  within section_id do
    first(".form-edit-link").click
    fill_in("assessor_assignment_level_of_innovation_desc", with: text)
    all(".form-edit-link").last.click
    fill_in("assessor_assignment_verdict_desc", with: text2)
    all(".form-save-link").last.click
  end

  sleep(0.5)
  visit show_path
  find("#{header_id} .panel-title a").click

  within section_id do
    expect(page).to have_selector(".form-value p", text: text2, count: 1)
    expect(page).to have_selector(".form-value p", text: text, count: 0)
    all(".form-edit-link").last.click
    expect(page).to have_selector("textarea", text: text2)
  end
end

def assert_verdict_change(section_id, header_id)
  find("#{header_id} .panel-title a").click

  within section_id do
    expect(page).to have_selector(".rag-text", text: "Select verdict", count: 1)
    all(".btn-rag").last.click
    find(".dropdown-menu .rag-positive").click
  end

  sleep(0.5)
  visit show_path
  page.find("#{header_id} .panel-title a").click

  within section_id do
    expect(page).to_not have_selector(".rag-text", text: "Select verdict")
    expect(page).to have_selector(".rag-text", text: "Recommended", count: 1)
  end
  visit show_path
end

def show_path
  if scope == :assessor
    assessor_form_answer_path form_answer
  else
    admin_form_answer_path form_answer
  end
end
