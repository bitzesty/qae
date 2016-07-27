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
      document: { sic_code: "1623" })

    @forms << create(:form_answer, :trade, state: "application_in_progress")
    @forms << create(:form_answer, :development, state: "not_eligible")
    @forms << create(:form_answer, :promotion, state: "assessment_in_progress")
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

    let!(:assessor) { create(:assessor, :lead_for_development_promotion) }
    before do
      login_as(assessor, scope: :assessor)
      visit assessor_form_answers_path
    end

    context "promotion tab" do
      before do
        within ".nav-subnav" do
          find(".cat-enterprise-promotion").click
        end
      end
      it "filters by status" do
        assert_results_number(1)
        click_status_option("Assessment in progress")
        sleep(3)
        assert_results_number(0)
      end
    end

    context "development tab" do
      before do
        @forms << create(:form_answer, :development, state: "assessment_in_progress")

        @forms.last(1).map do |form|
          form.document["sic_code"] = nil
          form.save!(validate: false)
        end

        within ".nav-subnav" do
          find(".cat-sustainable-development").click
          expect(page).to have_selector("a", count: 2)
        end
        @development_forms = @forms.select(&:development?)
      end

      it "filters by status" do
        assert_results_number(1)
        click_status_option("Assessment in progress")
        sleep(3)
        assert_results_number(0)
      end

      describe "filtering by substatus" do
        before do
          FormAnswer.where(award_type: "development").each do |form|
            form.update_column(:state, "assessment_in_progress")
          end
          visit assessor_form_answers_path
        end

        it "filters by substatus" do
          assert_results_number(3)
          click_status_option("Missing SIC code")
          sleep(3)
          @development_forms.slice!(0)
          assert_results_number(2)
          click_status_option("Missing Audit Certificate")
          sleep(3)
          assert_results_number(2)
          click_status_option("Missing Audit Certificate")
          sleep(3)
          assert_results_number(2)
          assign_dummy_audit_certificate(@development_forms.slice!(0))
          click_status_option("Missing Audit Certificate")
          sleep(3)
          assert_results_number(1)
        end
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
      sleep(3)
      assert_results_number(0)
    end
  end
end
