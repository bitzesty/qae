class ApplicationMailer < Mail::Notify::Mailer
  include MailerHelper

  default(
    from: ENV["MAILER_FROM"] || "no-reply@kings-awards-enterprise.service.gov.uk",
    reply_to: "kingsawards@businessandtrade.gov.uk"
  )

  def send_mail_if_not_bounces(template_id, headers)
    return true if ::CheckAccountOnBouncesEmail.bounces_email?(headers[:to])

    view_mail(template_id, headers)
  end

  def subject_with_env_prefix(subject_str)
    if ::ServerEnvironment.local_or_dev_or_staging_server?
      "#{::ServerEnvironment.env_prefix_in_mailers} #{subject_str}"
    else
      subject_str
    end
  end

  def set_end_of_embargo_deadline
    @end_of_embargo = deadlines.where(kind: "buckingham_palace_attendees_details").first
    @end_of_embargo_time = formatted_deadline_time(@end_of_embargo)
  end

  def set_media_deadline
    @media_deadline = deadlines.where(kind: "buckingham_palace_media_information").first
  end

  def set_press_summary_deadline
    @press_summary_deadline = deadlines.where(kind: "buckingham_palace_confirm_press_book_notes").first
    @press_summary_deadline_time = formatted_deadline_time(@press_summary_deadline)
  end

  def set_reception_deadlines
    @reception_deadline = deadlines.where(kind: "buckingham_palace_reception_attendee_information_due_by").first
    @reception_deadline_time = formatted_deadline_time(@reception_deadline)
    @reception_date = deadlines.where(kind: "buckingham_palace_attendees_invite").first
    @reception_start_time = formatted_deadline_time(@reception_date)
  end

  def deadlines
    @_deadlines ||= Settings.current.deadlines
  end
end
