require "rails_helper"

describe EmailNotificationDecorator do
  let(:email_notification) { EmailNotification.new(trigger_at: Time.current) }
  let(:subject) { EmailNotificationDecorator.decorate(email_notification) }

  describe "#header" do
    EmailNotification::NOTIFICATION_KINDS.each do |kind|
      context kind.to_s do
        it "returns the expected value on translation" do
          email_notification.kind = kind
          expect(subject.header).to eq(I18n.t("email_notification_headers.#{kind}"))
        end
      end
    end
  end
end
