require "rails_helper"

describe Notifiers::Submission::SuccessNotifier do
  include ActiveJob::TestHelper

  let!(:user) { create :user }
  let!(:collaborator) { create :user, account: user.account, role: "regular" }

  let!(:form_answer) do
    FactoryBot.create :form_answer, :submitted, :innovation,
                      user:
  end

  describe "#run" do
    describe "Scheduling of delayed mailers" do
      before do
        clear_enqueued_jobs
        Notifiers::Submission::SuccessNotifier.new(form_answer).run
      end

      it "should schedule delayed mails to all necessary recipients" do
        expect(enqueued_jobs.size).to be_eql(2)
      end
    end

    describe "Deliver" do
      before do
        ActionMailer::Base.deliveries.clear
        Users::SubmissionMailer.success(user.id, form_answer.id).deliver_now!
      end

      it "should deliver emails about submission created to all necessary recipients" do
        expect(ActionMailer::Base.deliveries.count).to eq 1
        email = ActionMailer::Base.deliveries.last
        expect(email.to).to eq [user.email]
      end
    end
  end
end
