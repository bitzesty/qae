class Notifiers::EmailNotificationService
  attr_reader :email_notifications

  def self.run
    new.run
  end

  def initialize
    @email_notifications = Settings.current.email_notifications.where("trigger_at < ?", Time.now.utc).where(sent: false)
  end

  def run
    email_notifications.each do |notification|
      public_send(notification.kind)

      notification.update_column(:sent, true)
    end
  end

  # this will be removed after all methods are implemented
  %w(reminder_to_submit ep_reminder_support_letters winners_notification winners_reminder_to_submit winners_press_release_comments_request unsuccessfull_notification all_unsuccessfull_feedback).each do |method|
    define_method method do
      nil
    end
  end

  def shortlisted_notifier
    User.shortlisted.each do |user|
      Users::NotifyShortlistedMailer.notify(user).deliver_later!
    end
  end

  def not_shortlisted_notifier
    User.non_shortlisted.each do |user|
      Users::NotifyNonShortlistedMailer.notify(user).deliver_later!
    end
  end

  def shortlisted_audit_certificate_reminder
    FormAnswer.shortlisted_with_no_certificate.each do |form_answer|
      Notifiers::Shortlist::AuditCertificateRequest.new(form_answer).run
    end
  end
end
