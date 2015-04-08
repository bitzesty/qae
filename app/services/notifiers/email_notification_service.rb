class Notifiers::EmailNotificationService
  attr_reader :email_notifications

  def self.run
    new.run
  end

  def initialize
    @email_notifications = Settings.current.email_notifications.current
  end

  def run
    email_notifications.each do |notification|
      public_send(notification.kind)

      notification.update_column(:sent, true)
    end
  end

  # this will be removed after all methods are implemented
  %w(reminder_to_submit ep_reminder_support_letters winners_reminder_to_submit unsuccessful_notification).each do |method|
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

  def all_unsuccessful_feedback
    FormAnswer.unsuccessful.each do |form_answer|
      Users::UnsuccessfulFeedbackMailer.notify(form_answer.id).deliver_later!
    end
  end

  def winners_notification
    FormAnswer.winners.each do |form_answer|
      document = form_answer.document

      if form_answer.promotion?
        Notifiers::Winners::PromotionBuckinghamPalaceInvite.perform_async(document["nominee_email"],
                                                                          form_answer)
      else
        Notifiers::Winners::BuckinghamPalaceInvite.perform_async(document["head_email"],
                                                                 form_answer)
      end
    end
  end

  def winners_press_release_comments_request
    FormAnswer.winners.includes(:press_summary).each do |form_answer|
      ps = form_answer.press_summary

      if ps && ps.approved? && !ps.reviewed_by_user?
        Users::WinnersPressRelease.notify(form_answer.id).deliver_later!
      end
    end
  end

  private

  def current_award_year
    # TODO: discuss a way to detect award year to use it in scopes here
  end
end
