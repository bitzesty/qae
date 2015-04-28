class Notifiers::EmailNotificationService
  attr_reader :email_notifications

  def self.run
    new.run
  end

  def initialize
    @email_notifications = AwardYear.current.settings.email_notifications.current.to_a
    @email_notifications += AwardYear.closed.settings.email_notifications.current.to_a
  end

  def run
    email_notifications.each do |notification|
      public_send(notification.kind, notification.settings.award_year)

      notification.update_column(:sent, true)
    end
  end

  # this will be removed after all methods are implemented
  %w(ep_reminder_support_letters winners_reminder_to_submit unsuccessful_notification).each do |method|
    define_method method do
      nil
    end
  end

  def reminder_to_submit(award_year)
    award_year.form_answers.business.where(submitted: false).each do |form_answer|
      user = form_answer.user
      Users::ReminderToSubmitMailer.notify(user.id, form_answer.id).deliver_later!
    end
  end

  def shortlisted_notifier(award_year)
    User.shortlisted.each do |user|
      Users::NotifyShortlistedMailer.notify(user).deliver_later!
    end
  end

  def not_shortlisted_notifier(award_year)
    User.non_shortlisted.each do |user|
      Users::NotifyNonShortlistedMailer.notify(user).deliver_later!
    end
  end

  def shortlisted_audit_certificate_reminder(award_year)
    award_year.form_answers.shortlisted_with_no_certificate.each do |form_answer|
      Notifiers::Shortlist::AuditCertificateRequest.new(form_answer).run
    end
  end

  def all_unsuccessful_feedback(award_year)
    award_year.form_answers.unsuccessful.each do |form_answer|
      Users::UnsuccessfulFeedbackMailer.notify(form_answer.id).deliver_later!
    end
  end

  def winners_notification(award_year)
    award_year.form_answers.winners.each do |form_answer|
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

  def winners_press_release_comments_request(award_year)
    award_year.form_answers.winners.includes(:press_summary).each do |form_answer|
      ps = form_answer.press_summary

      if ps && ps.approved? && !ps.reviewed_by_user?
        Users::WinnersPressRelease.notify(form_answer.id).deliver_later!
      end
    end
  end
end
