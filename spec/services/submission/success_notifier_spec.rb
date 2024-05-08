require "rails_helper"

describe Notifiers::Submission::SuccessNotifier do
  let!(:user) { create :user }
  let!(:collaborator) { create :user, account: user.account, role: "regular" }

  let!(:form_answer) do
    FactoryBot.create :form_answer, :submitted, :innovation, user: user
  end

  describe "#run" do
    describe "Scheduling of delayed mailers" do
      it "should schedule delayed mails to all necessary recipients" do
        notifier = Notifiers::Submission::SuccessNotifier.new(form_answer)
        expect { notifier.run }.to change { MailDeliveryWorker.jobs.size }.by(2)
      end
    end

    describe "Deliver" do
      before do
        ActionMailer::Base.deliveries.clear
      end

      it "should deliver emails about submission created to all necessary recipients" do
        Users::SubmissionMailer.success(user.id, form_answer.id).deliver_now!

        email = ActionMailer::Base.deliveries.last

        expect(ActionMailer::Base.deliveries.count).to eq 1
        expect(email.to).to eq [user.email]
      end
    end
  end
end
