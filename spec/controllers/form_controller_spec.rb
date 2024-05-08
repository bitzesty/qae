require "rails_helper"

describe FormController do
  let!(:award_year) { AwardYear.current }
  let(:user) { create :user, :completed_profile, role: "account_admin" }
  let(:account) { user.account }
  let!(:collaborator) { create :user, :completed_profile, role: "regular", account: account }
  let(:form_answer) do
    create :form_answer,
      :innovation,
      user: user,
      account: account,
      award_year: award_year
  end

  let!(:settings) { create(:settings, :submission_deadlines) }

  before do
    create :basic_eligibility, account: account

    sign_in user
    described_class.skip_before_action :check_basic_eligibility, :check_award_eligibility, :check_account_completion, raise: false
  end

  it "sends email after submission" do
    notifier = double
    expect(notifier).to receive(:run)
    expect(Notifiers::Submission::SuccessNotifier).to receive(:new).with(form_answer) { notifier }
    expect_any_instance_of(FormAnswer).to receive(:eligible?).at_least(:once).and_return(true)

    post :save, params: {
      id: form_answer.id,
      form: form_answer.document,
      current_step_id: form_answer.award_form.steps.last.title.parameterize,
      submit: "true"
    }
  end

  describe "#new_international_trade_form" do
    it "allows to open trade form if it is the first one" do
      expect(get :new_international_trade_form).to redirect_to(edit_form_url(FormAnswer.where(award_type: "trade").last))
    end

    it "denies to open trade form if it is not the first one" do
      create :form_answer,
        :trade,
        user: user
      expect(get :new_international_trade_form).to redirect_to(dashboard_url)
    end
  end

  describe "#new_social_mobility_form" do
    it "allows to open mobility form" do
      expect(get :new_social_mobility_form).to redirect_to(edit_form_url(FormAnswer.where(award_type: "mobility").last))
    end
  end

  context "individual deadlines" do
    describe "#new_international_trade_form" do
      it "allows to create an application if trade start deadline has past" do
        expect(get :new_international_trade_form).to redirect_to(edit_form_url(FormAnswer.where(award_type: "trade").last))
      end

      it "does not allow to create an application if trade start deadline has not past" do
        Settings.current.deadlines.trade_submission_start.update_column(:trigger_at, Time.zone.now + 1.day)
        expect(get :new_international_trade_form).to redirect_to(dashboard_url)
      end
    end

    describe "#new_social_mobility_form" do
      it "allows to create an application if mobility deadline has past" do
        expect(get :new_social_mobility_form).to redirect_to(edit_form_url(FormAnswer.where(award_type: "mobility").last))
      end

      it "does not allow to create an application if mobility start deadline has not past" do
        Settings.current.deadlines.mobility_submission_start.update_column(:trigger_at, Time.zone.now + 1.day)
        expect(get :new_social_mobility_form).to redirect_to(dashboard_url)
      end
    end

    describe "#new_sustainable_development_form" do
      it "allows to create an application if trade development deadline has past" do
        expect(get :new_sustainable_development_form).to redirect_to(edit_form_url(FormAnswer.where(award_type: "development").last))
      end

      it "does not allow to create an application if development start deadline has not past" do
        Settings.current.deadlines.development_submission_start.update_column(:trigger_at, Time.zone.now + 1.day)
        expect(get :new_sustainable_development_form).to redirect_to(dashboard_url)
      end
    end

    describe "#new_innovation_form" do
      it "allows to create an application if innovation start deadline has past" do
        expect(get :new_innovation_form).to redirect_to(edit_form_url(FormAnswer.where(award_type: "innovation").last))
      end

      it "does not allow to create an application if innovation start deadline has not past" do
        Settings.current.deadlines.innovation_submission_start.update_column(:trigger_at, Time.zone.now + 1.day)
        expect(get :new_innovation_form).to redirect_to(dashboard_url)
      end
    end
  end
end
