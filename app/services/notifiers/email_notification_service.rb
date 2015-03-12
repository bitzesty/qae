class Notifiers::EmailNotificationService
  attr_reader :email_notifications

  MAPPER = {
    shortlisted_audit_certificate_reminder: {
      class: 'Notifiers::Shortlist::AuditCertificateRequest',
      iterate_on: 'FormAnswer',
      scope: 'shortlisted_with_no_certificate'
    }
  }

  def self.run
    new.run
  end

  def initialize
    @email_notifications = Settings.current.email_notifications.where("trigger_at < ?", Time.now.utc).where(sent: false)
  end

  def run
    email_notifications.each do |notification|
      if settings = notification_settings(notification.kind)
        entities = settings[:iterate_on].constantize.public_send(settings[:scope])

        entities.each do |entity|
          service = settings[:class].constantize
          service.new(entity).run
        end

        notification.update_column(:sent, true)
      end
    end
  end

  private

  def notification_settings(kind)
    MAPPER[kind.to_sym]
  end
end
