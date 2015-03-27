require "rails_helper"

include Warden::Test::Helpers
include FormAnswerFilteringTestHelper

Warden.test_mode!

describe "As Lead Assessor I want to filter applications by state", js: true do
  before do
    @forms = []
    @forms << create(
      :form_answer,
      :development,
      state: "not_submitted",
      sic_code: "1623")

    @forms << create(:form_answer, :trade, state: "application_in_progress")
    @forms << create(:form_answer, :development, state: "not_eligible")
    @forms << create(:form_answer, :promotion, state: "assessment_in_progress")
    @forms << create(:form_answer, :innovation, state: "assessment_in_progress")
  end

  context "for multi tabs" do
    # if assessor assigned to many categories sees the applications grouped by
    # these categories, not applicable for the admin

    let!(:assessor) { create(:assessor, :lead_for_development_promotion) }
    before do
      login_as(assessor, scope: :assessor)
      visit assessor_form_answers_path
    end

    context "promotion tab" do
      before do
        within ".nav-pills" do
          find("a", text: "Enterprise promotion").click
        end
      end
      it "filters by status" do
        assert_results_number(1)
        click_status_option("Assessment in progress")
        assert_results_number(0)
      end
    end

    context "development tab" do
      before do
        @forms << create(:form_answer, :development, state: "assessment_in_progress")
        within ".nav-pills" do
          find("a", text: "Sustainable Development").click
          expect(page).to have_selector("a", count: 2)
        end
        @development_forms = @forms.select(&:development?)
      end

      it "filters by status" do
        assert_results_number(3)
        click_status_option("Assessment in progress")
        assert_results_number(2)
        click_status_option("Not Eligible")
        assert_results_number(1)
      end

      it "filters by substatus" do
        assert_results_number(3)
        click_status_option("Missing SIC code")
        @development_forms.slice!(0)
        assert_results_number(2)
        click_status_option("Missing Audit Certificate")
        assert_results_number(2)
        click_status_option("Missing Audit Certificate")
        assert_results_number(2)
        assign_dummy_audit_certificate(@development_forms.slice!(0))
        click_status_option("Missing Audit Certificate")
        assert_results_number(1)
      end
    end
  end

  context "single tab" do
    let!(:assessor) { create(:assessor, :lead_for_innovation) }
    before do
      create(:form_answer, :innovation, state: "assessment_in_progress")

      login_as(assessor, scope: :assessor)
      visit assessor_form_answers_path
    end

    it "filters by status" do
      assert_results_number(2)
      click_status_option("Assessment in progress")
      assert_results_number(0)
    end
  end
end
