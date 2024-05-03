require "rails_helper"
include Warden::Test::Helpers
Warden.test_mode!

describe "Progress halt" do
  let!(:award_year) { AwardYear.current }

  let!(:user) { create(:user, :completed_profile) }
  let!(:account) { user.reload.account }

  let!(:form_answer) do
    create :form_answer, :trade, user:, account:
  end

  let!(:basic_eligibility) do
    create :basic_eligibility, form_answer:, account:
  end

  let!(:trade_eligibility) do
    create :trade_eligibility, form_answer:, account:
  end

  let!(:questions) { form_answer.award_form.steps.map { |s| s.questions.map(&:key) }.flatten }

  before do
    create(:settings, :submission_deadlines)
    login_as(user, scope: :user)
  end

  context "trade" do
    before do
      form_answer.document.tap do |h|
        h["overseas_sales_1of3"] = ""
        h["overseas_sales_2of3"] = ""
        h["overseas_sales_3of3"] = ""
      end

      form_answer.save(validate: false)

      visit edit_form_path(form_answer.id, step: "commercial-performance")
    end

    it "halts progress" do
      within("div[data-step=\"step-commercial-performance\"]") do
        within("div[data-question-key=\"overseas_sales\"]") do
          fill_in("form[overseas_sales_1of3]", with: "110100")
          fill_in("form[overseas_sales_2of3]", with: "100000")
          fill_in("form[overseas_sales_3of3]", with: "110100")
        end

        click_button "Save and continue"

        within("div[data-question-key=\"overseas_sales\"] > .govuk-form-group > .if-js-hide") do
          expect(page).not_to have_selector(".govuk-error-summary.govuk-visually-hidden")
          expect(page).to have_selector(".govuk-error-summary.govuk-error-summary--question-halted", count: 1)
          expect(page).to have_selector(".govuk-error-summary .govuk-error-summary__title",
                                        text: "You do not meet the eligibility criteria for this award.")
          expect(page).to have_selector(".govuk-error-summary .govuk-error-summary__body",
                                        text: "Your total overseas sales are showing dips during the period of your entry. Therefore, you do not meet eligibility for the award and cannot proceed.")
        end
      end

      visible, hidden = questions.partition.with_index do |_k, idx|
        idx <= questions.index(:overseas_sales)
      end

      visible.each do |k|
        selector = "[data-question-key=\"#{k}\"].js-question-disabled"
        expect(page).not_to have_selector(selector, match: :first)
      end

      hidden.each do |k|
        selector = "[data-question-key=\"#{k}\"].js-question-disabled"
        expect(page).to have_selector(selector, match: :first)
      end

      expect(page).to have_selector("li.submit.js-next-link.js-step-link.js-link-disabled", count: 5)

      %w[step-consent-due-diligence step-company-information step-your-international-trade step-commercial-performance].each do |k|
        expect(page).not_to have_selector(".steps-progress-bar ul li[data-step=\"#{k}\"].js-step-disabled")
        expect(page).to have_selector(".steps-progress-bar ul li[data-step=\"#{k}\"]", count: 1)
      end

      %w[step-environmental-social-corporate-governance-esg step-supplementary-materials-confirmation].each do |k|
        expect(page).to have_selector(".steps-progress-bar ul li[data-step=\"#{k}\"].js-step-disabled", count: 1)
      end
    end
  end
end
