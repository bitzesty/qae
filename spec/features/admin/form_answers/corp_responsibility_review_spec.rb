require "rails_helper"
include Warden::Test::Helpers

describe "Corp responsibility Review" do
  let!(:admin) { create(:admin) }

  let!(:deadline) do
    d = Settings.current_submission_deadline
    d.trigger_at = DateTime.now - 1.day
    d.save!

    d
  end

  before do
    login_admin(admin)
  end

  describe "Policies" do
    let!(:not_business_form_answer) do
      create(:form_answer, :promotion, :recommended)
    end

    let!(:not_shortlisted_form_answer) do
      create(:form_answer, :trade, :submitted)
    end

    describe "Not business app" do
      before do
        visit admin_form_answer_path(not_business_form_answer)
      end

      it "should do not display DCR" do
        within("#section-application-info") do
          expect_to_see_no "Declaration of Corporate Responsibility"
        end
      end
    end

    describe "Not shortlisted app" do
      before do
        visit admin_form_answer_path(not_shortlisted_form_answer)
      end

      it "should do not display DCR" do
        within("#section-application-info") do
          expect_to_see_no "Declaration of Corporate Responsibility"
        end
      end
    end
  end

  describe "Review", js: true do
    let!(:form_answer) { create(:form_answer, :trade, :recommended) }
    describe "Mark as Reviewed" do
      before do
        visit admin_form_answer_path(form_answer)
      end

      it "should allow to mark as reviewed" do
        within("#corp-responsibility-section") do
          expect_to_see "DECLARATION OF CORPORATE RESPONSIBILITY"

          find("a[aria-controls='corp-responsibility']").click

          expect_to_see "Not reviewed"
          expect_to_see_no "Reviewed"

          click_link "Edit"

          first("input[type='checkbox']").set(true)

          click_link "Save"
          wait_for_ajax

          expect_to_see "Reviewed"
          expect_to_see_no "Not reviewed"

          expect(form_answer.reload.corp_responsibility_reviewed).to be_truthy
        end
      end

      describe "Unmark as Reviewed" do
        before do
          form_answer.corp_responsibility_reviewed = true
          form_answer.save!

          visit admin_form_answer_path(form_answer)
        end

        it "should allow to mark as not reviewed" do
          within("#corp-responsibility-section") do
            expect_to_see "DECLARATION OF CORPORATE RESPONSIBILITY"

            find("a[aria-controls='corp-responsibility']").click

            expect_to_see "Reviewed"
            expect_to_see_no "Not reviewed"

            click_link "Edit"

            first("input[type='checkbox']").set(false)

            click_link "Save"
            wait_for_ajax

            expect_to_see "Not reviewed"
            expect_to_see_no "Reviewed"

            expect(form_answer.reload.corp_responsibility_reviewed).to be_falsey
          end
        end
      end
    end
  end
end
