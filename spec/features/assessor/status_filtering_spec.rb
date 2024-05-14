require "rails_helper"

include Warden::Test::Helpers
include FormAnswerFilteringTestHelper

Warden.test_mode!

describe "As Lead Assessor I want to filter applications by state", js: true do
  before do
    @forms = []
    @forms << create(
      :form_answer,
      :trade,
      state: "not_submitted",
      document: { sic_code: "1623" })

    @forms << create(:form_answer, :development, state: "application_in_progress")
    @forms << create(:form_answer, :trade, state: "not_eligible")

    mob = create(:form_answer, :mobility, state: "assessment_in_progress")
    mob.document["product_estimated_figures"] = "yes"
    mob.document["product_estimates_use"] = "text"
    mob.save!
    @forms << mob

    @forms << create(:form_answer, :innovation, state: "assessment_in_progress")

    # 0111 - is default sic_code, came from spec/fixtures/*.json
    # as it is required field
    # so that we are cleaning it up for last 3
    #
    @forms.last(4).map do |form|
      form.document["sic_code"] = nil
      form.save!(validate: false)
    end
  end

  context "for multi tabs" do
    # if assessor assigned to many categories sees the applications grouped by
    # these categories, not applicable for the admin

    let!(:assessor) { create(:assessor, :lead_for_trade, :lead_for_innovation) }
    before do
      login_as(assessor, scope: :assessor)
      visit assessor_form_answers_path
    end

    context "innovation tab" do
      before do
        within ".nav-subnav" do
          find(".cat-innovation").click
        end
      end
      it "filters by status" do
        assert_results_number(1)
        click_status_option("Assessment in progress")
        wait_for_ajax
        assert_results_number(0)
      end
    end

    context "trade tab" do
      before do
        @forms << create(:form_answer, :trade, state: "assessment_in_progress")

        @forms.last(1).map do |form|
          form.document["sic_code"] = nil
          form.save!(validate: false)
        end

        within ".nav-subnav" do
          find(".cat-international-trade").click
          expect(page).to have_selector("a", count: 2)
        end
        @trade_forms = @forms.select(&:trade?)
      end

      it "filters by status" do
        assert_results_number(1)
        click_status_option("Assessment in progress")
        wait_for_ajax
        assert_results_number(0)
      end

      describe "filtering by substatus" do
        before do
          FormAnswer.where(award_type: "trade").each do |form|
            form.update_column(:state, "assessment_in_progress")
          end
          visit assessor_form_answers_path
        end

        it "filters by substatus" do
          assert_results_number(3)
          click_status_option("Missing SIC code")
          wait_for_ajax
          @trade_forms.slice!(0)
          assert_results_number(2)
          click_status_option("Missing additional financials")
          wait_for_ajax
          assert_results_number(2)
          click_status_option("Missing additional financials")
          wait_for_ajax
          assert_results_number(2)
          assign_dummy_audit_certificate(@trade_forms.slice!(0))
          click_status_option("Missing additional financials")
          wait_for_ajax
          assert_results_number(1)
        end
      end
    end
  end

  context "single tab" do
    let!(:assessor) { create(:assessor, :lead_for_mobility) }
    before do
      create(:form_answer, :mobility, state: "assessment_in_progress")

      login_as(assessor, scope: :assessor)
      visit assessor_form_answers_path
    end

    it "filters by status" do
      assert_results_number(2)
      click_status_option("Assessment in progress")
      wait_for_ajax
      assert_results_number(0)
    end
  end
end
