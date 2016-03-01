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

  context "shortlisted_audit_certificate_reminder" do
    let(:kind) { "shortlisted_audit_certificate_reminder" }
    let(:form_answer) { create(:form_answer, :trade, :submitted) }

    it "triggers current notification" do
      service = double
      expect(service).to receive(:run)
      expect(Notifiers::Shortlist::AuditCertificateRequest).to receive(:new)
        .with(form_answer) { service }

      expect(FormAnswer).to receive(:shortlisted) { [form_answer] }

      described_class.run

      expect(current_notification.reload).to be_sent
    end
  end

  context "not_shortlisted_notifier" do
    let(:kind) { "not_shortlisted_notifier" }
    let(:form_answer) { create(:form_answer, state: "not_recommended") }

    it "triggers current notification" do
      mailer = double(deliver_later!: true)
      expect(Users::NotifyNonShortlistedMailer).to receive(:notify).with(form_answer.id) { mailer }

      described_class.run

      expect(current_notification.reload).to be_sent
    end
  end

  context "shortlisted_notifier" do
    let(:kind) { "shortlisted_notifier" }
    let(:form_answer) { create(:form_answer, state: "recommended") }

    it "triggers current notification" do
      mailer = double(deliver_later!: true)
      expect(Users::NotifyShortlistedMailer).to receive(:notify).with(form_answer.id) { mailer }

      described_class.run

      expect(current_notification.reload).to be_sent
    end
  end

  context "winners_notifier" do
    let(:kind) { "winners_notification" }

    it "triggers current notification" do
      form_answer = create(:form_answer, :trade, :submitted)
      form_answer.document = form_answer.document
      form_answer.save!

      account_holder = form_answer.account.owner

      expect(Notifiers::Winners::BuckinghamPalaceInvite).to receive(:perform_async)
        .with({email: account_holder.email, form_answer_id: form_answer.id})
      expect(FormAnswer).to receive(:winners) { [form_answer] }

      described_class.run

      expect(current_notification.reload).to be_sent
    end

    it "triggers current notification" do
      form_answer = build(:form_answer, :promotion, :submitted)
      form_answer.document = form_answer.document.merge(nominee_email: "nominee@email.com")
      form_answer.save!

      expect(Notifiers::Winners::PromotionBuckinghamPalaceInvite).to receive(:perform_async)
        .with({email: "nominee@email.com", form_answer_id: form_answer.id})
      expect(FormAnswer).to receive(:winners) { [form_answer] }

      described_class.run

      expect(current_notification.reload).to be_sent
    end
  end

  context "winners_press_release_comments_request" do
    let(:kind) { "winners_press_release_comments_request" }
    let(:user) { create(:user) }

    let(:form_answer) do
      create(:form_answer, :trade, :submitted, user: user)
    end

    let(:press_summary) do
      create :press_summary, form_answer: form_answer, approved: true
    end

    it "triggers current notification" do
      press_summary
      mailer = double(deliver_later!: true)
      expect(Users::WinnersPressRelease).to receive(:notify).with(form_answer.id, user.id) { mailer }
      expect(FormAnswer).to receive(:winners) { FormAnswer.where(id: form_answer.id) }

      described_class.run

      expect(current_notification.reload).to be_sent
    end
  end

  context "reminder_to_submit" do
    let(:kind) { "reminder_to_submit" }

    let(:form_answer) do
      create(:form_answer, :trade)
    end

    it "triggers current notification" do
      mailer = double(deliver_later!: true)
      expect(Users::ReminderToSubmitMailer).to receive(:notify).with(form_answer.id) { mailer }

      described_class.run

      expect(current_notification.reload).to be_sent
    end
  end

  context "ep_reminder_support_letters" do
    let(:kind) { "ep_reminder_support_letters" }

    let(:form_answer) do
      create(:form_answer, :promotion)
    end

    it "triggers current notification" do
      mailer = double(deliver_later!: true)
      expect(Users::PromotionLettersOfSupportReminderMailer).to receive(:notify).with(form_answer.id) { mailer }

      described_class.run

      expect(current_notification.reload).to be_sent
    end
  end

  context "unsuccessful_notification" do
    let(:kind) { "unsuccessful_notification" }
    let(:user) { create(:user) }

    let(:form_answer) { create(:form_answer, :trade, state: "not_awarded", user: user) }
    let!(:certificate) { create(:audit_certificate, form_answer: form_answer) }

    it "triggers current notification" do
      mailer = double(deliver_later!: true)
      expect(Users::UnsuccessfulFeedbackMailer).to receive(:notify).with(form_answer.id, user.id) { mailer }

      described_class.run

      expect(current_notification.reload).to be_sent
    end
  end

  context "unsuccessful_ep_notification" do
    let(:kind) { "unsuccessful_ep_notification" }
    let(:user) { create(:user) }

    let(:form_answer) { create(:form_answer, :promotion, state: "not_awarded", user: user) }

    it "triggers current notification" do
      mailer = double(deliver_later!: true)
      expect(Users::UnsuccessfulFeedbackMailer).to receive(:ep_notify).with(form_answer.id, user.id) { mailer }

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
      expect(Users::WinnersHeadOfOrganisationMailer).to receive(:notify).with(form_answer.id) { mailer }

      described_class.run

      expect(current_notification.reload).to be_sent
    end
  end
end
