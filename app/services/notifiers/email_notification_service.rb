class Notifiers::EmailNotificationService
  attr_reader :email_notifications

  def self.run
    log_this("started") unless Rails.env.test?

    new.run

    log_this("completed") unless Rails.env.test?
  end

  def initialize
    @email_notifications = AwardYear.current.settings.email_notifications.current.to_a
    if AwardYear.current != AwardYear.closed
      @email_notifications += AwardYear.closed.settings.email_notifications.current.to_a
    end
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
    award_year.form_answers.business.unsuccessful_applications.each do |form_answer|
      Users::UnsuccessfulFeedbackMailer.notify(form_answer.id).deliver_later!
    end
  end

  def unsuccessful_ep_notification(award_year)
    award_year.form_answers.promotion.unsuccessful_applications.each do |form_answer|
      Users::UnsuccessfulFeedbackMailer.ep_notify(form_answer.id).deliver_later!
    end
  end

  def winners_notification(award_year)
    award_year.form_answers.business.winners.each do |form_answer|
      opts = {
        email: form_answer.user.email,
        form_answer_id: form_answer.id
      }

      # Prevent of sending real request to AWS on dev and test environments
      if %w{bzstaging staging production}.include?(Rails.env)
        Notifiers::Winners::BuckinghamPalaceInvite.perform_async(opts)
      else
        invite = PalaceInvite.where(
          email: opts[:email],
          form_answer_id: opts[:form_answer_id]
        ).first_or_create

        Users::BuckinghamPalaceInviteMailer.invite(invite.id).deliver_later!
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
