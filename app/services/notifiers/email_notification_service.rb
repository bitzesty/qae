class Notifiers::EmailNotificationService
  attr_reader :email_notifications

  def self.run
    log_this("started") unless Rails.env.test?

    new.run

    log_this("completed") unless Rails.env.test?
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

  def ep_reminder_support_letters(award_year)
    award_year.form_answers.promotion.includes(:support_letters).each do |form_answer|
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
      Users::NotifyShortlistedMailer.notify(form_answer.id).deliver_later!
    end
  end

  def not_shortlisted_notifier(award_year)
    award_year.form_answers.business.not_shortlisted.each do |form_answer|
      Users::NotifyNonShortlistedMailer.notify(form_answer.id).deliver_later!
    end
  end

  def shortlisted_audit_certificate_reminder(award_year)
    award_year.form_answers.business.shortlisted.each do |form_answer|
      if !form_answer.audit_certificate
        Notifiers::Shortlist::AuditCertificateRequest.new(form_answer).run
      end
    end
  end

  def unsuccessful_notification(award_year)
    award_year.form_answers.business.non_winners.each do |form_answer|
      form_answer.account.users.each do |user|
        Users::UnsuccessfulFeedbackMailer.notify(form_answer.id, user.id).deliver_later!
      end
    end
  end

  def unsuccessful_ep_notification(award_year)
    award_year.form_answers.promotion.non_winners.each do |form_answer|
      form_answer.account.users.each do |user|
        Users::UnsuccessfulFeedbackMailer.ep_notify(form_answer.id, user.id).deliver_later!
      end
    end
  end

  def winners_notification(award_year)
    award_year.form_answers.winners.each do |form_answer|
      document = form_answer.document
      email = form_answer.promotion? ? document["nominee_email"] : form_answer.user.email

      shoryuken_ops = {
        email: email,
        form_answer_id: form_answer.id
      }

      if form_answer.promotion?
        Notifiers::Winners::PromotionBuckinghamPalaceInvite.perform_async(shoryuken_ops)
      else
        Notifiers::Winners::BuckinghamPalaceInvite.perform_async(shoryuken_ops)
      end
    end
  end

  def winners_press_release_comments_request(award_year)
    award_year.form_answers.winners.includes(:press_summary).each do |form_answer|
      ps = form_answer.press_summary

      if ps && ps.approved? && !ps.reviewed_by_user?
        form_answer.account.users.each do |user|
          Users::WinnersPressRelease.notify(form_answer.id, user.id).deliver_later!
        end
      end
    end
  end

  # to 'Head of Organisation' of the Successful Business categories winners
  def winners_head_of_organisation_notification(award_year)
    award_year.form_answers.business.winners.each do |form_answer|
      Users::WinnersHeadOfOrganisationMailer.notify(form_answer.id).deliver_later!
    end
  end

  class << self
    def log_this(message)
      p "[EmailNotificationService] #{Time.zone.now} #{message}"
    end
  end
end
