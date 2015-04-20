require 'rails_helper'

describe FormController do
  let!(:award_year) { AwardYear.current }
  let(:user) { create :user, role: "account_admin" }
  let(:account) { user.account }
  let(:form_answer) do
    FactoryGirl.create :form_answer, :innovation,
                                     user: user,
                                     account: account,
                                     award_year: award_year
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

    post :save, id: form_answer.id, form: form_answer.document, submit: "true"
  end

  describe '#new_international_trade_form' do
    it 'allows to open trade form if it is the first one' do
      expect(get :new_international_trade_form).to redirect_to(edit_form_url(FormAnswer.where(award_type: 'trade').last))
    end

    it 'denies to open trade form if it is not the first one' do
      FactoryGirl.create :form_answer, :trade,
                                       user: user
      expect(get :new_international_trade_form).to redirect_to(dashboard_url)
    end
  end

  describe "#edit_form" do
    let!(:form_answer) do
      FactoryGirl.create :form_answer, award_type: "trade",
                                       user: user,
                                       account: account,
                                       award_year: award_year
    end

    context "adds award info to the form" do
      before do
        allow_any_instance_of(FormAnswer).to receive(:eligible?).and_return(true)

        el = account.basic_eligibility
        el.answers = {
          kind: "application",
          based_in_uk: true,
          has_management_and_two_employees: true,
          organization_kind: "business",
          industry: "product_business",
          self_contained_enterprise: true,
          current_holder: "yes"
        }
        el.save!

        trade_el = form_answer.build_trade_eligibility(account: account)
        trade_el.update!(
          sales_above_100_000_pounds: "yes",
          any_dips_over_the_last_three_years: true,
          current_holder_of_qae_for_trade: true,
          qae_for_trade_award_year: "2015"
        )
      end

      it "adds award if it is 5 or less years old" do
        get :edit_form, id: form_answer.id

        expect(form_answer.reload.document["queen_award_holder_details"]).to eq([{category: "international_trade", year: "2015"}.to_json].to_json)
        expect(form_answer.document["queen_award_holder"]).to eq("yes")
      end

      it "ingonres award if it is 5 or more years old" do
        trade_el = form_answer.trade_eligibility
        trade_el.update!(
          sales_above_100_000_pounds: "yes",
          any_dips_over_the_last_three_years: true,
          current_holder_of_qae_for_trade: true,
          qae_for_trade_award_year: "before_2011"
        )

        get :edit_form, id: form_answer.id

        expect(form_answer.reload.document["queen_award_holder_details"]).to be_nil
        expect(form_answer.document["queen_award_holder"]).to eq("no")
      end

      it "does nothing there was no award" do
        trade_el = form_answer.trade_eligibility
        trade_el.update!(
          sales_above_100_000_pounds: "yes",
          any_dips_over_the_last_three_years: true,
          current_holder_of_qae_for_trade: false
        )
        get :edit_form, id: form_answer.id

        expect(form_answer.reload.document["queen_award_holder_details"]).to be_nil
        expect(form_answer.document["queen_award_holder"]).to eq("no")
      end
    end
  end
end
