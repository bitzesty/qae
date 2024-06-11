require "rails_helper"

describe "As Admin I want to filter applications", js: true do
  include FormAnswerFilteringTestHelper
  Warden.test_mode!

  let!(:admin) { create(:admin) }

  before do
    @forms = []
    @forms << create(:form_answer, :trade, state: "not_submitted", document: { sic_code: "1623" })
    @forms << create(:form_answer, :trade, state: "application_in_progress")

    dev = create(:form_answer, :development, state: "not_eligible")
    dev.document["product_estimated_figures"] = "yes"
    dev.document["product_estimates_use"] = "text"
    dev.save!
    @forms << dev

    mob = create(:form_answer, :mobility, state: "application_in_progress")
    mob.document["product_estimated_figures"] = "yes"
    mob.document["product_estimates_use"] = "text"
    mob.save!

    @forms << mob

    # 0111 - is default sic_code, came from spec/fixtures/*.json
    # as it is required field
    # so that we are cleaning it up for last 3
    #
    @forms.last(3).map do |form|
      form.document["sic_code"] = nil
      form.save!(validate: false)
    end

    login_admin(admin)
    visit admin_form_answers_path
  end

  it "filters by status" do
    # 4 Applications
    assert_results_number(4)

    click_status_option("Application in progress")
    assert_results_number(2)

    click_status_option("Application in progress")
    assert_results_number(4)

    click_status_option("Applications not submitted")
    assert_results_number(3)

    click_status_option("Not eligible")
    assert_results_number(2)
  end

  it "filters by sub options" do
    # 4 Applications
    assert_results_number(4)

    click_status_option("Missing SIC code")
    assert_results_number(3)

    # Add assesors to all applications and check filter
    assign_dummy_assessors(@forms, create(:assessor, :lead_for_all))
    click_status_option("Assessors not assigned")
    assert_results_number(0)

    # Uncheck filter
    click_status_option("Assessors not assigned")
    assert_results_number(3)

    # Add Verification of Commercial Figures to the first 2 applications and check filter
    first_two_forms = @forms.slice(0..1)
    assign_dummy_audit_certificate(first_two_forms)
    click_status_option("Missing additional financials")
    assert_results_number(2)

    # Add feedback to the first 3 applications and check filter
    first_three_forms = @forms.slice(0..2)
    assign_dummy_feedback(first_three_forms)
    click_status_option("Missing Feedback")
    assert_results_number(1)

    # Add press summary to all applications and check filter
    assign_dummy_press_summary(@forms)
    click_status_option("Missing Press Summary")
    assert_results_number(0)
  end
end
