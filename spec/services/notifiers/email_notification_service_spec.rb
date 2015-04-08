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
    let(:form_answer) { create(:form_answer, :submitted) }

    it "triggers current notification" do
      service = double
      expect(service).to receive(:run)
      expect(Notifiers::Shortlist::AuditCertificateRequest).to receive(:new)
        .with(form_answer) { service }

      expect(FormAnswer).to receive(:shortlisted_with_no_certificate) { [form_answer] }

      described_class.run

      expect(current_notification.reload).to be_sent
    end
  end

  context "not_shortlisted_notifier" do
    let(:kind) { "not_shortlisted_notifier" }
    let(:user) { create(:user) }

    it "triggers current notification" do
      mailer = double(deliver_later!: true)
      expect(Users::NotifyNonShortlistedMailer).to receive(:notify).with(user) { mailer }
      expect(User).to receive(:non_shortlisted) { [user] }

      described_class.run

      expect(current_notification.reload).to be_sent
    end
  end

  context "shortlisted_notifier" do
    let(:kind) { "shortlisted_notifier" }
    let(:user) { create(:user) }

    it "triggers current notification" do
      mailer = double(deliver_later!: true)
      expect(Users::NotifyShortlistedMailer).to receive(:notify).with(user) { mailer }
      expect(User).to receive(:shortlisted) { [user] }

      described_class.run

      expect(current_notification.reload).to be_sent
    end
  end

  context "winners_notifier" do
    let(:kind) { "winners_notification" }

    it "triggers current notification" do
      form_answer = create(:form_answer, :submitted, document:
                           { head_email: "head@email.com" })

      expect(Notifiers::Winners::BuckinghamPalaceInvite).to receive(:perform_async)
        .with("head@email.com", form_answer)
      expect(FormAnswer).to receive(:winners) { [form_answer] }

      described_class.run

      expect(current_notification.reload).to be_sent
    end

    it "triggers current notification" do
      form_answer = create(:form_answer, :promotion, :submitted,
                           document: { nominee_email: "nominee@email.com" })

      expect(Notifiers::Winners::PromotionBuckinghamPalaceInvite).to receive(:perform_async)
        .with("nominee@email.com", form_answer)
      expect(FormAnswer).to receive(:winners) { [form_answer] }

      described_class.run

      expect(current_notification.reload).to be_sent
    end
  end

  context "winners_press_release_comments_request" do
    let(:kind) { "winners_press_release_comments_request" }
    let(:user) { create(:user) }

    let(:form_answer) do
      create(:form_answer, :submitted)
    end

    let(:press_summary) do
      create :press_summary, form_answer: form_answer, approved: true
    end

    it "triggers current notification" do
      press_summary
      mailer = double(deliver_later!: true)
      expect(Users::WinnersPressRelease).to receive(:notify).with(form_answer.id) { mailer }
      expect(FormAnswer).to receive(:winners) { FormAnswer.where(id: form_answer.id) }

      described_class.run

      expect(current_notification.reload).to be_sent
    end
  end

  context "all_unsuccessful_feedback" do
    let(:kind) { "all_unsuccessful_feedback" }

    let(:form_answer) do
      create(:form_answer, :submitted)
    end

    before do
      form_answer.update_column(:state, "not_awarded")
    end

    it "triggers current notification" do
      mailer = double(deliver_later!: true)
      expect(Users::UnsuccessfulFeedbackMailer).to receive(:notify).with(form_answer.id) { mailer }

      described_class.run

      expect(current_notification.reload).to be_sent
    end
  end
end
