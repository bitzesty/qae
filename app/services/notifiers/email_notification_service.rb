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

  %w(innovation trade mobility development).each do |award|
    define_method "#{award}_submission_started_notification" do |award_year|
      submission_started_notification(award_year, award)
    end
  end

  def submission_started_notification(award_year, award_type)
    user_ids = User.confirmed.pluck(:id)

    user_ids.each do |user_id|
      Users::SubmissionStartedNotificationMailer.notify(
        user_id,
        award_type
      ).deliver_later!
    end
  end

  def ep_reminder_support_letters(award_year)
    collaborator_data = []

    award_year.form_answers.promotion.includes(:support_letters).each do |form_answer|
      next unless form_answer.support_letters.count < 2

      form_answer.collaborators.each do |collaborator|
        collaborator_data << { form_answer_id: form_answer.id, collaborator_id: collaborator.id }
      end
    end

    send_emails_to_collaborators!(collaborator_data, AccountMailers::PromotionLettersOfSupportReminderMailer)
  end

  def reminder_to_submit(award_year)
    collaborator_data = []
    scope = award_year.form_answers.business.where(submitted_at: nil)

    scope.each do |form_answer|
      form_answer.collaborators.each do |collaborator|
        unless collaborator.notification_when_submission_deadline_is_coming?
          collaborator_data << { form_answer_id: form_answer.id, collaborator_id: collaborator.id }
        end
      end
    end

    send_emails_to_collaborators!(
      collaborator_data, AccountMailers::ReminderToSubmitMailer
    )
  end

  def shortlisted_notifier(award_year)
    gather_data_and_send_emails!(
      award_year.form_answers.business.shortlisted,
      AccountMailers::NotifyShortlistedMailer
    )
  end

  def not_shortlisted_notifier(award_year)
    gather_data_and_send_emails!(
      award_year.form_answers.business.not_shortlisted,
      AccountMailers::NotifyNonShortlistedMailer
    )
  end

  def shortlisted_audit_certificate_reminder(award_year)
    collaborator_data = []

    award_year.form_answers.business.shortlisted.each do |form_answer|
      next if form_answer.audit_certificate

      form_answer.collaborators.each do |collaborator|
        collaborator_data << { form_answer_id: form_answer.id, collaborator_id: collaborator.id }
      end
    end

    send_emails_to_collaborators!(collaborator_data, Users::AuditCertificateRequestMailer)
  end

  def unsuccessful_notification(award_year)
    gather_data_and_send_emails!(
      award_year.form_answers.business.unsuccessful_applications,
      AccountMailers::UnsuccessfulFeedbackMailer
    )
  end

  def unsuccessful_ep_notification(award_year)
    gather_data_and_send_emails!(
      award_year.form_answers.promotion.unsuccessful_applications,
      AccountMailers::UnsuccessfulFeedbackMailer
    )
  end

  def winners_notification(award_year)
    gather_data_and_send_emails!(
      award_year.form_answers.business.winners,
      AccountMailers::BusinessAppsWinnersMailer
    )
  end

  # to 'Head of Organisation' of the Successful Business categories winners
  def winners_head_of_organisation_notification(award_year)
    awarded_application_ids = award_year.form_answers.business.winners.pluck(:id)

    awarded_application_ids.each do |form_answer_id|
      Users::WinnersHeadOfOrganisationMailer.notify(form_answer_id).deliver_later!
    end
  end

  def buckingham_palace_invite(award_year)
    form_answer_ids = []

    award_year.form_answers.business.winners.each do |form_answer|

      invite = PalaceInvite.where(
        email: form_answer.decorate.head_email,
        form_answer_id: form_answer.id
      ).first_or_create

      unless invite.submitted?
        form_answer_ids << form_answer.id
      end
    end

    form_answer_ids.each do |form_answer_id|
      AccountMailers::BuckinghamPalaceInviteMailer.invite(form_answer_id).deliver_later!
    end
  end

  class << self
    def log_this(message)
      p "[EmailNotificationService] #{Time.zone.now} #{message}"
    end
  end

  private

  def formatted_collaborator_data(scope)
    collaborator_data = []

    scope.each do |form_answer|
      form_answer.collaborators.each do |collaborator|
        collaborator_data << { form_answer_id: form_answer.id, collaborator_id: collaborator.id }
      end
    end

    collaborator_data
  end

  def gather_data_and_send_emails!(scope, mailer)
    collaborator_data = formatted_collaborator_data(scope)
    send_emails_to_collaborators!(collaborator_data, mailer)
  end

  def send_emails_to_collaborators!(data, mailer)
    data.each do |entry|
      mailer.notify(
        entry[:form_answer_id],
        entry[:collaborator_id]
      ).deliver_later!
    end
  end
end
