require 'rails_helper'

describe FormController do
  let(:user) { create :user }
  let(:form_answer) do
    FactoryGirl.create :form_answer, :innovation,
                                     user: user,
                                     document: { company_name: "Bitzesty" }
  end

  before do
    sign_in user
    described_class.skip_before_action :check_basic_eligibility, :check_award_eligibility, :check_account_completion
  end

  it 'sends email after submission' do
    notifier = double
    expect(notifier).to receive(:run)
    expect(Notifiers::Submission::SuccessNotifier).to receive(:new).with(form_answer) { notifier }
    expect_any_instance_of(FormAnswer).to receive(:eligible?) { true }

    post :submit_form, id: form_answer.id, form: {}
  end
end
