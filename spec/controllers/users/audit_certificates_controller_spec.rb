require "rails_helper"

describe Users::AuditCertificatesController, type: :controller do
  let!(:user) { create :user, :completed_profile, role: "account_admin" }
  let!(:award_year) { AwardYear.current }
  let!(:form_answer) { create(:form_answer, :innovation, user: user, award_year: award_year) }

  before do
    sign_in user
  end

  describe "GET show" do
    describe "before the financial statement deadline" do
      let!(:settings) { create(:settings) }

      it "should render the template" do
        get :show, params: { form_answer_id: form_answer.id }

        expect(response).to render_template(:show)
      end
    end

    describe "after the financial statement deadline" do
      let!(:settings) { create(:settings, :expired_audit_submission_deadline) }

      describe "without an audit certificate" do
        it "should redirect to the dashboard" do
          get :show, params: { form_answer_id: form_answer.id }

          expect(response).to redirect_to dashboard_url
          expect(flash[:alert]).to eq("You cannot upload the Verification of Commercial Figures after the deadline.")
        end
      end

      describe "with an audit certificate" do
        let!(:audit_certificate) { create(:audit_certificate, form_answer: form_answer) }
        it "should render the template" do
          get :show, params: { form_answer_id: form_answer.id }

          expect(response).to render_template(:show)
        end
      end
    end
  end

  describe "DELETE destroy" do
    describe "after the financial statement deadline" do
      let!(:settings) { create(:settings, :expired_audit_submission_deadline) }
      let!(:audit_certificate) { create(:audit_certificate, form_answer: form_answer) }

      it "should redirect to the dashboard" do
        delete :destroy, params: { form_answer_id: form_answer.id }

        expect(response).to redirect_to dashboard_url
        expect(flash[:alert]).to eq("You cannot amend the Verification of Commercial Figures after the deadline.")
      end
    end
  end
end
