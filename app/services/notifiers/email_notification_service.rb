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
  %w(winners_reminder_to_submit).each do |method|
    define_method method do
      nil
    end
  end

  def ep_reminder_support_letters(award_year)
    award_year.form_answers.where(award_type: "promotion").includes(:support_letters).each do |form_answer|
      if form_answer.support_letters.count < 2
        Users::PromotionLettersOfSupportReminderMailer.notify(form_answer.id).deliver_later!
      end
    end
  end

  def reminder_to_submit(award_year)
    award_year.form_answers.business.where(submitted: false).each do |form_answer|
      Users::ReminderToSubmitMailer.notify(form_answer.id).deliver_later!
    end
  end

  def shortlisted_notifier(award_year)
    award_year.form_answers.business.shortlisted.each do |form_answer|
      Users::NotifyShortlistedMailer.notify(form_answer.user_id).deliver_later!
    end
  end

  def ep_shortlisted_notifier(award_year)
  end

  def ep_not_shortlisted_notifier(award_year)
  end

  def not_shortlisted_notifier(award_year)
    award_year.form_answers.not_shortlisted.each do |form_answer|
      Users::NotifyNonShortlistedMailer.notify(form_answer.user_id).deliver_later!
    end
  end

  def shortlisted_audit_certificate_reminder(award_year)
    award_year.form_answers.shortlisted_with_no_certificate.each do |form_answer|
      Notifiers::Shortlist::AuditCertificateRequest.new(form_answer).run
    end
  end

  def unsuccessful_notification(award_year)
    # initialy shortlisted but then did not win
    award_year.form_answers.business.unsuccessful.each do |form_answer|
      if form_answer.audit_certificate
        Users::ShortlistedUnsuccessfulFeedbackMailer.notify(form_answer.id).deliver_later!
      end
    end
  end

  def all_unsuccessful_feedback(award_year)
    award_year.form_answers.business.unsuccessful.each do |form_answer|
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
