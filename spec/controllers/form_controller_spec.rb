require 'rails_helper'

describe FormController do
  let(:user) { create :user, role: "account_admin" }
  let(:account) { user.account }
  let(:form_answer) do
    FactoryGirl.create :form_answer, :innovation,
                                     user: user,
                                     account: account,
                                     document: { company_name: "Bitzesty" }
  end

  let!(:settings) { create :settings, :submission_deadlines }

  before do
    create :basic_eligibility, account: account

    sign_in user
    described_class.skip_before_action :check_basic_eligibility, :check_award_eligibility, :check_account_completion
  end

  it 'sends email after submission' do
    notifier = double
    expect(notifier).to receive(:run)
    expect(Notifiers::Submission::SuccessNotifier).to receive(:new).with(form_answer) { notifier }
    expect_any_instance_of(FormAnswer).to receive(:eligible?).at_least(:once).and_return(true)

    post :save, id: form_answer.id, form: {}, submit: "true"
  end

  describe '#new_international_trade_form' do
    it 'allows to open trade form if it is the first one' do
      expect(get :new_international_trade_form).to redirect_to(edit_form_url(FormAnswer.where(award_type: 'trade').last))
    end

    it 'denies to open trade form if it is not the first one' do
      FactoryGirl.create :form_answer, :trade,
                                       user: user,
                                       document: { company_name: "Bitzesty" }
      expect(get :new_international_trade_form).to redirect_to(dashboard_url)
    end
  end
end
