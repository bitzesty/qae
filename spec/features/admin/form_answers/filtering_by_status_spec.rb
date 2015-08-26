require "rails_helper"

include Warden::Test::Helpers
include FormAnswerFilteringTestHelper

Warden.test_mode!

describe "As Admin I want to filter applications", js: true do
  let!(:admin) { create(:admin) }

  before do
    @forms = []
    @forms << create(:form_answer, :trade, state: "not_submitted", sic_code: "1623")
    @forms << create(:form_answer, :trade, state: "application_in_progress")
    @forms << create(:form_answer, :development, state: "not_eligible")
    @forms << create(:form_answer, :promotion, state: "application_in_progress")

    login_admin(admin)
    visit admin_form_answers_path
  end

  it "filters by status" do
    assert_results_number(4)
    click_status_option("Application in progress")
    sleep(3)
    assert_results_number(2)
    click_status_option("Application in progress")
    sleep(3)
    assert_results_number(4)
    click_status_option("Applications not submitted")
    sleep(3)
    assert_results_number(3)
    click_status_option("Not eligible")
    sleep(3)
    assert_results_number(2)
  end

  it "filters by sub options" do
    assert_results_number(4)
    click_status_option("Missing SIC code")
    sleep(3)
    @forms.slice!(0)
    assert_results_number(3)
    click_status_option("Assessors not assigned")
    sleep(3)
    assert_results_number(3)
    click_status_option("Assessors not assigned")
    sleep(3)
    assert_results_number(3)
    assign_dummy_assessors(@forms, create(:assessor, :lead_for_all))
    click_status_option("Assessors not assigned")
    sleep(3)
    assert_results_number(0)
    click_status_option("Assessors not assigned")
    sleep(3)
    assert_results_number(3)
    click_status_option("Missing Audit Certificate")
    sleep(3)
    assert_results_number(3)
    click_status_option("Missing Audit Certificate")
    sleep(3)
    assert_results_number(3)
    assign_dummy_audit_certificate(@forms.slice!(0))
    click_status_option("Missing Audit Certificate")
    sleep(3)
    assert_results_number(2)
    assign_dummy_feedback(@forms.slice!(0), true)
    assign_dummy_feedback(@forms[0], false)
    click_status_option("Missing Feedback")
    sleep(3)
    assert_results_number(1)
    click_status_option("Missing Press Summary")
    sleep(3)
    assert_results_number(1)
    click_status_option("Missing Press Summary")
    sleep(3)
    assert_results_number(1)
    assign_dummy_feedback(@forms.slice!(0))
    click_status_option("Missing Press Summary")
    sleep(3)
    assert_results_number(0)
  end
end
