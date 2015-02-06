require 'rails_helper'

describe QuestionnaireController do
  let(:user) { create :user, role: "account_admin" }
  let!(:form_answer) do
    FactoryGirl.create :form_answer, :innovation,
                                     user: user,
                                     document: { company_name: "Bitzesty" }
  end

  before do
    sign_in user
    described_class.skip_before_action :check_basic_eligibility, :check_award_eligibility, :check_account_completion
  end

  it 'redirects to form url if form is not submitted' do
    expect(get :show, id: form_answer.id).to redirect_to(edit_form_url(form_answer))
  end

  context 'with submitted form' do
    let(:questionnaire) { create(:questionnaire, form_answer: form_answer) }

    before do
      form_answer.update_column(:submitted, true)
    end

    it 'redirects to submit page if questionnaire was completed before' do
      questionnaire.update_column(:completed, true)
      expect(get :show, id: form_answer.id).to redirect_to(submit_confirm_url(form_answer))
    end

    it 'renders questionnaire' do
      get :show, id: form_answer.id
      expect(response).to render_template(:show)
    end
  end
end
