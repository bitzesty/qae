require 'rails_helper'

describe FormController do
  let!(:award_year) { AwardYear.current }
  let(:user) { create :user, role: "account_admin" }
  let(:account) { user.account }
  let(:form_answer) do
    create :form_answer,
           :innovation,
           user: user,
           account: account,
           award_year: award_year
  end

  let!(:settings) { Settings.current }

  before do
    start = settings.deadlines.where(kind: "submission_start").first
    start.update_column(:trigger_at, Time.zone.now - 20.days)
    finish = settings.deadlines.where(kind: "submission_end").first
    finish.update_column(:trigger_at, Time.zone.now + 20.days)

    create :basic_eligibility, account: account

    sign_in user
    described_class.skip_before_action :check_basic_eligibility, :check_award_eligibility, :check_account_completion
  end

  it 'sends email after submission' do
    notifier = double
    expect(notifier).to receive(:run)
    expect(Notifiers::Submission::SuccessNotifier).to receive(:new).with(form_answer) { notifier }
    expect_any_instance_of(FormAnswer).to receive(:eligible?).at_least(:once).and_return(true)

    post :save, id: form_answer.id,
                form: form_answer.document,
                current_step_id: form_answer.award_form.steps.last.title.parameterize,
                submit: "true"
  end

  describe '#new_international_trade_form' do
    it 'allows to open trade form if it is the first one' do
      expect(get :new_international_trade_form).to redirect_to(edit_form_url(FormAnswer.where(award_type: 'trade').last))
    end

    it 'denies to open trade form if it is not the first one' do
      create :form_answer,
             :trade,
             user: user
      expect(get :new_international_trade_form).to redirect_to(dashboard_url)
    end
  end

  describe '#new_social_mobility_form' do
    it 'allows to open mobility form if it is the first one' do
      expect(get :new_social_mobility_form).to redirect_to(edit_form_url(FormAnswer.where(award_type: 'mobility').last))
    end

    it 'denies to open mobility form if it is not the first one' do
      create :form_answer,
             :mobility,
             user: user
      expect(get :new_social_mobility_form).to redirect_to(dashboard_url)
    end
  end
end
