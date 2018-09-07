require "rails_helper"

describe Notifiers::EmailNotificationService do
  let!(:sent_notification) do
    create(:email_notification, trigger_at: Time.now - 1.day, sent: true, kind: kind)
  end

  let!(:current_notification) do
    create(:email_notification, trigger_at: Time.now - 1.day, kind: kind)
  end

  let!(:future_notification) do
    create(:email_notification, trigger_at: Time.now + 1.day, kind: kind)
  end

  let(:user) do
    form_answer.user
  end

  context "submission_started_notification" do
    let(:kind) { "submission_started_notification" }

    let(:user) do
      create(:user)
    end

    it "triggers current notification" do
      mailer = double(deliver_later!: true)

      expect(Users::SubmissionStartedNotificationMailer).to receive(:notify).with(
        user.id
      ) { mailer }

      described_class.run

      expect(current_notification.reload).to be_sent
    end
  end

  context "shortlisted_audit_certificate_reminder" do
    let(:kind) { "shortlisted_audit_certificate_reminder" }
    let(:form_answer) { create(:form_answer, :trade, :submitted) }

    it "triggers current notification" do
      mailer = double(deliver_later!: true)
      expect(Users::AuditCertificateRequestMailer).to receive(:notify).with(
        form_answer.id,
        user.id
      ) { mailer }

      expect(FormAnswer).to receive(:shortlisted) { [form_answer] }

      described_class.run

      expect(current_notification.reload).to be_sent
    end

    context "with already submitted certificate" do
      let!(:certificate) { create(:audit_certificate, form_answer: form_answer) }

      it "triggers current notification" do
        expect(Users::AuditCertificateRequestMailer).not_to receive(:notify)

        expect(FormAnswer).to receive(:shortlisted) { [form_answer] }

        described_class.run

        expect(current_notification.reload).to be_sent
      end
    end
  end

  context "not_shortlisted_notifier" do
    let(:kind) { "not_shortlisted_notifier" }
    let(:form_answer) { create(:form_answer, state: "not_recommended") }

    it "triggers current notification" do
      mailer = double(deliver_later!: true)
      expect(AccountMailers::NotifyNonShortlistedMailer).to receive(:notify).with(
        form_answer.id,
        user.id
      ) { mailer }

      described_class.run

      expect(current_notification.reload).to be_sent
    end
  end

  context "shortlisted_notifier" do
    let(:kind) { "shortlisted_notifier" }
    let(:form_answer) { create(:form_answer, state: "recommended") }

    it "triggers current notification" do
      mailer = double(deliver_later!: true)
      expect(AccountMailers::NotifyShortlistedMailer).to receive(:notify).with(
        form_answer.id,
        user.id
      ) { mailer }

      described_class.run

      expect(current_notification.reload).to be_sent
    end
  end

  context "winners_notifier" do
    let(:kind) { "winners_notification" }
    let(:form_answer) { create(:form_answer, :trade, :awarded) }

    it "triggers current notification" do
      mailer = double(deliver_later!: true)
      expect(AccountMailers::BusinessAppsWinnersMailer).to receive(:notify).with(
        form_answer.id,
        user.id
      ) { mailer }

      described_class.run

      expect(current_notification.reload).to be_sent
    end
  end

  context "buckingham_palace_invite" do
    let(:kind) { "buckingham_palace_invite" }
    let!(:form_answer) { create(:form_answer, :trade, :awarded) }
    let!(:account_holder) { form_answer.account.owner }

    it "triggers current notification" do
      mailer = double(deliver_later!: true)
      expect(AccountMailers::BuckinghamPalaceInviteMailer).to receive(:invite).with(form_answer.id) { mailer }

      expect {
        described_class.run
      }.to change {
        PalaceInvite.count
      }.by(1)

      last_invite = PalaceInvite.last
      expect(last_invite.email).to be_eql form_answer.decorate.head_email
      expect(last_invite.form_answer_id).to be_eql form_answer.id

      expect(current_notification.reload).to be_sent
    end

    context "for an application with submitted attendees details" do
      it "does not send an invite" do
        create(:palace_invite,
               email: form_answer.decorate.head_email,
               form_answer: form_answer,
               submitted: true)

        expect(AccountMailers::BuckinghamPalaceInviteMailer).not_to receive(:invite)

        expect {
          described_class.run
        }.not_to change {
          PalaceInvite.count
        }

        expect(current_notification.reload).to be_sent
      end
    end
  end

  describe "#reminder_to_submit" do
    let(:kind) { "reminder_to_submit" }
    let(:mailer) { double(deliver_later!: true) }

    context "for not submitted aplications" do
      let(:form_answer) do
        create(:form_answer, :trade)
      end

      it "triggers current notification" do
        expect(AccountMailers::ReminderToSubmitMailer).to receive(:notify).with(
          form_answer.id,
          user.id
        ) { mailer }

        described_class.run

        expect(current_notification.reload).to be_sent
      end
    end

    context "for submitted aplications" do
      let(:form_answer) do
        create(:form_answer, :trade, :submitted)
      end

      it "does not send email notification" do
        expect(AccountMailers::ReminderToSubmitMailer).not_to receive(:notify).with(
          form_answer.id,
          user.id
        ) { mailer }

        described_class.run

        expect(current_notification.reload).to be_sent
      end
    end
  end

  context "ep_reminder_support_letters" do
    let(:kind) { "ep_reminder_support_letters" }

    let(:form_answer) do
      create(:form_answer, :promotion)
    end

    it "triggers current notification" do
      pending "EP forms are not present for 2019"
      mailer = double(deliver_later!: true)
      expect(AccountMailers::PromotionLettersOfSupportReminderMailer).to receive(:notify).with(
        form_answer.id,
        user.id
      ) { mailer }

      described_class.run

      expect(current_notification.reload).to be_sent
    end
  end

  context "unsuccessful_notification" do
    let(:kind) { "unsuccessful_notification" }

    let(:form_answer) { create(:form_answer, :trade, :submitted, state: "not_awarded") }
    let!(:certificate) { create(:audit_certificate, form_answer: form_answer) }

    it "triggers current notification" do
      mailer = double(deliver_later!: true)
      expect(AccountMailers::UnsuccessfulFeedbackMailer).to receive(:notify).with(
        form_answer.id,
        user.id
      ) { mailer }

      described_class.run

      expect(current_notification.reload).to be_sent
    end
  end

  context "unsuccessful_ep_notification" do
    let(:kind) { "unsuccessful_ep_notification" }

    let(:form_answer) { create(:form_answer, :promotion, :submitted, state: "not_awarded") }

    it "triggers current notification" do
      pending "EP forms are not present for 2019"

      mailer = double(deliver_later!: true)
      expect(AccountMailers::UnsuccessfulFeedbackMailer).to receive(:ep_notify).with(
        form_answer.id,
        user.id
      ) { mailer }

      described_class.run

      expect(current_notification.reload).to be_sent
    end
  end

  context "winners_head_of_organisation_notification" do
    let(:kind) { "winners_head_of_organisation_notification" }
    let(:user) { create(:user) }

    let(:form_answer) do
      create(:form_answer, :trade, :awarded)
    end

    it "triggers current notification" do
      mailer = double(deliver_later!: true)
      expect(Users::WinnersHeadOfOrganisationMailer).to receive(:notify).with(
        form_answer.id
      ) { mailer }

      described_class.run

      expect(current_notification.reload).to be_sent
    end
  end
end
