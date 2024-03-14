class MailRenderer
  include MailerHelper

  class View < ActionView::Base
    extend ApplicationHelper
    include ActionView::Helpers
    include Rails.application.routes.url_helpers

    def default_url_options
      {host: "www.kings-awards-enterprise.service.gov.uk"}
    end

    def compiled_method_container
      return self.class
    end
  end

  def submission_started_notification
    #
    # NOTE: This one is old.
    #       But we still need it here in order to show it for previous years
    #
    assigns = {}

    assigns[:user] = dummy_user("Jon", "Doe", "Jane's Company")
    assigns[:award_type] = "International Trade"

    render(assigns, "users/submission_started_notification_mailer/preview/notify")
  end

  def award_year_open_notifier
    assigns = {}
    assigns[:user] = dummy_user("Jon", "Doe", "Jane's Company")

    render(assigns, "users/award_year_open_notification_mailer/preview/notify")
  end

  def innovation_submission_started_notification
    year_open_award_type_specific_notification("innovation")
  end

  def trade_submission_started_notification
    year_open_award_type_specific_notification("trade")
  end

  def development_submission_started_notification
    year_open_award_type_specific_notification("development")
  end

  def mobility_submission_started_notification
    year_open_award_type_specific_notification("mobility")
  end

  def unsuccessful_notification
    assigns = {}

    assigns[:name] = "Mr Smith"
    assigns[:user] = dummy_user("Jon", "Doe", "Jane's Company")
    assigns[:form_answer] = form_answer
    assigns[:year] = AwardYear.closed.year
    form_answer.urn = "QA0001/16I"

    render(assigns, "account_mailers/unsuccessful_feedback_mailer/preview/notify")
  end

  def unsuccessful_ep_notification
    assigns = {}

    assigns[:user] = dummy_user("Jon", "Doe", "Jane's Company")
    assigns[:form_answer] = form_answer
    assigns[:nominee_name] = "Nominee Name"
    assigns[:year] = AwardYear.closed.year
    form_answer.urn = "QA0128/16EP"

    render(assigns, "account_mailers/unsuccessful_feedback_mailer/preview/ep_notify")
  end

  def ep_reminder_support_letters
    assigns = {}

    assigns[:user] = dummy_user("Jon", "Doe", "Jane's Company")
    assigns[:form_answer] = form_answer
    assigns[:days_before_submission] = "N"
    assigns[:deadline] = deadline_str("submission_end")
    assigns[:nominee_name] = "Jane Doe"

    render(assigns, "account_mailers/promotion_letters_of_support_reminder_mailer/preview/notify")
  end

  def reminder_to_submit
    assigns = {}

    assigns[:user] = dummy_user("Jon", "Doe", "Jane's Company")
    assigns[:form_answer] = form_answer
    deadline_time = deadline_time("submission_end")
    assigns[:deadline] = deadline_str("submission_end", "#{deadline_time} on %A %d %B %Y")

    render(assigns, "account_mailers/reminder_to_submit_mailer/preview/notify")
  end

  def shortlisted_audit_certificate_reminder
    assigns = {}

    assigns[:recipient] = dummy_user("Jane", "Doe", "Jane's Company")
    assigns[:form_answer] = form_answer
    assigns[:deadline] = deadline_str("audit_certificates")
    assigns[:deadline_time] = deadline_time("audit_certificates")

    render(assigns, "users/audit_certificate_request_mailer/preview/notify")
  end

  def shortlisted_po_sd_reminder
    assigns = {}

    assigns[:recipient] = dummy_user("Jane", "Doe", "Jane's Company").decorate
    assigns[:form_answer] = form_answer
    assigns[:deadline] = deadline_str("audit_certificates")
    assigns[:deadline_time] = deadline_time("audit_certificates")

    render(assigns, "users/shortlisted_reminder_mailer/preview/notify")
  end

  def not_shortlisted_notifier
    assigns = {}
    assigns[:user] = dummy_user("Jon", "Doe", "John's Company")
    assigns[:current_year] = AwardYear.current.year
    render(assigns, "account_mailers/notify_non_shortlisted_mailer/preview/notify")
  end

  def shortlisted_notifier
    assigns = {}
    assigns[:user] = dummy_user("Jon", "Doe", "John's Company")
    assigns[:form_answer] = form_answer
    assigns[:company_name] = "Massive Dynamic"

    assigns[:deadline_time] = deadline_time("audit_certificates")
    assigns[:deadline_date] = deadline_str("audit_certificates")

    assigns[:award_type_full_name] = "Innovation"

    render(assigns, "account_mailers/notify_shortlisted_mailer/preview/notify")
  end

  def shortlisted_po_sd_notifier
    assigns = {}
    assigns[:user] = dummy_user("Jon", "Doe", "John's Company")
    assigns[:form_answer] = form_answer
    assigns[:company_name] = "Massive Dynamic"

    assigns[:deadline_time] = deadline_time("audit_certificates")
    assigns[:deadline_date] = deadline_str("audit_certificates")

    assigns[:award_type_full_name] = "Sustainable Development"

    render(assigns, "account_mailers/notify_shortlisted_mailer/preview/notify_po_sd")
  end

  def shortlisted_po_sd_with_actual_figures_notifier
    assigns = {}
    assigns[:user] = dummy_user("Jon", "Doe", "John's Company")
    assigns[:form_answer] = form_answer
    assigns[:company_name] = "Massive Dynamic"

    assigns[:deadline_time] = deadline_time("audit_certificates")
    assigns[:deadline_date] = deadline_str("audit_certificates")

    assigns[:award_type_full_name] = "Sustainable Development"

    render(assigns, "account_mailers/notify_shortlisted_mailer/preview/notify_po_sd_with_actual_figures")
  end

  def winners_notification
    assigns = {}

    assigns[:form_answer] = form_answer
    assigns[:name] = "Mr Smith"

    assigns[:end_of_embargo] = deadline_str(
      "buckingham_palace_attendees_details",
      "%-d %B %Y"
    )

    end_of_embargo_time = deadline_time("buckingham_palace_attendees_details")
    assigns[:end_of_embargo_with_time] = deadline_str(
      "buckingham_palace_attendees_details",
      "#{end_of_embargo_time} on %-d %B %Y"
    )

    assigns[:end_of_embargo_without_year] = deadline_str(
      "buckingham_palace_attendees_details",
      "%-d %B"
    )

    assigns[:media_deadline] = deadline_str(
      "buckingham_palace_media_information",
      "%A %d %B %Y"
    )
    assigns[:book_notes_deadline] = deadline_str(
      "buckingham_palace_confirm_press_book_notes",
      "%A %d %B %Y"
    )
    book_notes_deadline_time = deadline_time("buckingham_palace_confirm_press_book_notes")
    assigns[:book_notes_deadline_with_time_and_day] = deadline_str(
      "buckingham_palace_confirm_press_book_notes",
      "#{book_notes_deadline_time} on %A %-d %B %Y"
    )

    assigns[:reception_date] = deadline_str(
      "buckingham_palace_attendees_invite",
      "%-d %B %Y"
    )

    render(assigns, "account_mailers/business_apps_winners_mailer/preview/notify")
  end

  def winners_head_of_organisation_notification
    assigns = {}
    form = form_answer

    assigns[:name] = "Mr Smith"
    assigns[:form_answer] = form
    assigns[:award_year] = form.award_year.year
    assigns[:urn] = "QAXXXX/#{assigns[:award_year].to_s[2..-1]}I"
    assigns[:award_category_title] = form.award_type_full_name
    assigns[:head_email] = "john@example.com"
    assigns[:head_of_business_full_name] = "Jon Doe"

    assigns[:end_of_embargo] = deadline_str(
      "buckingham_palace_attendees_details",
      "%-d %B %Y"
    )
    end_of_embargo_time = deadline_time("buckingham_palace_attendees_details")
    assigns[:end_of_embargo_with_time] = deadline_str(
      "buckingham_palace_attendees_details",
      "#{end_of_embargo_time} on %-d %B %Y"
    )

    assigns[:book_notes_deadline] = deadline_str(
      "buckingham_palace_confirm_press_book_notes",
      "%A %d %B %Y"
    )
    book_notes_deadline_time = deadline_time("buckingham_palace_confirm_press_book_notes")
    assigns[:book_notes_deadline_with_time_and_day] = deadline_str(
      "buckingham_palace_confirm_press_book_notes",
      "#{book_notes_deadline_time} on %A %-d %B %Y"
    )

    assigns[:media_deadline] = deadline_str(
      "buckingham_palace_media_information",
      "%A %d %B %Y"
    )

    assigns[:reception_date] = deadline_str(
      "buckingham_palace_attendees_invite",
      "%-d %B %Y"
    )

    render(assigns, "users/winners_head_of_organisation_mailer/preview/notify")
  end

  def buckingham_palace_invite
    assigns = {}

    assigns[:form_answer] = form_answer
    assigns[:name] = "John Smith"
    assigns[:token] = "securetoken"

    assigns[:reception_date] = deadline_str(
      "buckingham_palace_attendees_invite",
      "%A %-d %B %Y"
    )

    reception_deadline_time = deadline_time("buckingham_palace_reception_attendee_information_due_by")
    assigns[:reception_deadline_with_day_and_time] = deadline_str(
      "buckingham_palace_reception_attendee_information_due_by",
      "#{reception_deadline_time} on %A %-d %B %Y"
    )

    render(assigns, "account_mailers/buckingham_palace_invite_mailer/preview/invite")
  end

  private

  def render(assigns, template)
    view = View.with_view_paths(ActionController::Base.view_paths, assigns, nil)
    view.render(template: template)
  end

  def dummy_user(first_name, last_name, company_name)
    User.new(first_name: first_name, last_name: last_name, company_name: company_name).decorate
  end

  def form_answer
    @form_answer ||= FormAnswer
      .new(
        id: 0,
        urn: "QA0128/16I",
        award_type: "innovation",
        award_year: AwardYear.current,
        award_type_full_name: "Innovation"
      )
      .decorate
  end

  def deadline_str(kind, format = "%d/%m/%Y")
    trigger = deadline(kind).trigger_at
    trigger ? trigger.strftime(format) : DateTime.new(Date.current.year, 9, 21, 10, 30).strftime(format)
  end

  def deadline_time(kind)
    deadline = deadline(kind)
    deadline ? formatted_deadline_time(deadline) : "11:58pm"
  end

  def deadline(kind)
    Settings.current.deadlines.find_by(
      kind: kind
    )
  end

  def year_open_award_type_specific_notification(award_type)
    assigns = {}

    assigns[:user] = dummy_user("Jon", "Doe", "Jane's Company")
    assigns[:award_type] = FormAnswer::AWARD_TYPE_FULL_NAMES[award_type]

    render(assigns, "users/submission_started_notification_mailer/preview/notify")
  end
end
