require "rails_helper"

describe Submission::SuccessNotifier do
  let!(:user) { create :user }
  let!(:collaborator) { create :user }

  let!(:account) do 
    acc = user.account
    acc.users << collaborator
    acc.reload
  end

  let(:form_answer) do 
    FactoryGirl.create :form_answer, :submitted, :innovation,
                                                 user: user,
                                                 document: { company_name: "Bitzesty" }
  end

  before do
    FormAnswer.any_instance.stub(:eligible?) { true }
    form_answer
  end

  describe "#run" do
    describe "Scheduling of delayed mailers" do
      before do
        Submission::SuccessNotifier.new(form_answer).run
      end

      it "should schedule delayed mails to all necessary recipients" do
        expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to be_eql(2)
      end
    end

    describe "Deliver" do
      before do
        Users::SubmissionMailer.success(user.id, form_answer.id).deliver!
      end

      it "should deliver emails about submission created to all necessary recipients" do
        expect(ActionMailer::Base.deliveries.count).to eq 1
        email = ActionMailer::Base.deliveries.last
        expect(email.to).to eq [user.email]
      end
    end
  end
end
