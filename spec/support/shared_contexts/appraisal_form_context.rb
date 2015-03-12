shared_context "successful appraisal form edition" do
  let!(:form_answer) { create(:form_answer, :innovation) }
  let(:primary) { "#section-appraisal-form-primary" }
  let(:secondary) { "#section-appraisal-form-secondary" }
  let(:moderated) { "#section-appraisal-form-moderated" }
  let(:show_path) do
    if scope == :assessor
      assessor_form_answer_path form_answer
    else
      admin_form_answer_path form_answer
    end
  end

  before do
    login_as(subject, scope: scope)
    visit show_path
  end
  describe "Rag change" do
    let(:rag_case) do
      lambda do
        rag = ".rag-text"
        expect(page).to have_selector(rag, text: "Select RAG", count: 3)
        expect(page).to have_selector(rag, text: "Select verdict", count: 1)

        first(".btn-rag").click
        find(".dropdown-menu .rag-negative").click
        expect(page).to have_selector(rag, text: "Select RAG", count: 2)
        expect(page).to have_selector(rag, text: "Red", count: 1)
        expect(page).to have_selector(rag, text: "Select verdict", count: 1)
        sleep(0.5)
        visit show_path

        expect(page).to have_selector(rag, text: "Select RAG", count: 2)
        expect(page).to have_selector(rag, text: "Red", count: 1)
        expect(page).to have_selector(rag, text: "Select verdict", count: 1)
      end
    end

    it "updates the rag rate" do
      within(primary) { rag_case.call }
      within(secondary) { rag_case.call }
      within(moderated) { rag_case.call }
    end
  end

  describe "Description change" do
    let(:text) { "textareatext123" }

    let(:description_case) do
      lambda do
        first(".form-edit-link").click
        expect(page).to have_selector("textarea", count: 1)
        fill_in("assessor_assignment_level_of_innovation_desc", with: text)
        find(".form-save-link").click
        sleep(0.5)
        visit show_path
        expect(page).to have_selector(".form-value p", text: text, count: 1)
        first(".form-edit-link").click
        expect(page).to have_selector("textarea", text: text)
      end
    end

    it "updates the description" do
      within(primary) { description_case.call }
      within(secondary) { description_case.call }
      within(moderated) { description_case.call }
    end
  end

  describe "Overall verdict change" do
    let(:verdict_case) do
      lambda do
        expect(page).to have_selector(".rag-text", text: "Select verdict", count: 1)
        all(".btn-rag").last.click
        find(".dropdown-menu .rag-positive").click
        sleep(0.5)
        visit show_path
        expect(page).to_not have_selector(".rag-text", text: "Select verdict")
        expect(page).to have_selector(".rag-text", text: "Recommended", count: 1)
      end
    end
    it "updates verdict" do
      within(primary) { verdict_case.call }
      within(secondary) { verdict_case.call }
      within(moderated) { verdict_case.call }
    end
  end
end
