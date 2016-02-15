class MailRenderer
  class View < ActionView::Base
    extend ApplicationHelper
    include ActionView::Helpers
    include Rails.application.routes.url_helpers

    def default_url_options
      { host: "queens-awards-enterprise.service.gov.uk" }
    end
  end

  def unsuccessful_notification
    assigns = {}

    assigns[:user] = dummy_user("Jon", "Doe", "Jane's Company")
    assigns[:form_answer] = form_answer
    assigns[:nominee_name] = "Nominee Name"

    render(assigns, "users/shortlisted_unsuccessful_feedback_mailer/notify")
  end

  def ep_reminder_support_letters
    assigns = {}

    assigns[:user] = dummy_user("Jon", "Doe", "Jane's Company")
    assigns[:form_answer] = form_answer
    assigns[:days_before_submission] = "N"
    assigns[:deadline] = deadline_str("submission_end")
    assigns[:nominee_name] = "Jane Doe"

    render(assigns, "users/promotion_letters_of_support_reminder_mailer/notify")
  end

  def reminder_to_submit
    assigns = {}

    assigns[:user] = dummy_user("Jon", "Doe", "Jane's Company")
    assigns[:form_answer] = form_answer
    assigns[:days_before_submission] = "N"
    assigns[:deadline] = deadline_str("submission_end")

    render(assigns, "users/reminder_to_submit_mailer/notify")
  end

  def shortlisted_audit_certificate_reminder
    assigns = {}

    assigns[:recipient] = dummy_user("Jane", "Doe", "Jane's Company")
    assigns[:form_answer] = form_answer
    assigns[:deadline] = deadline_str("audit_certificates")

    render(assigns, "users/audit_certificate_request_mailer/notify")
  end

  def not_shortlisted_notifier
    assigns = {}
    assigns[:user] = dummy_user("Jon", "Doe", "John's Company")
    assigns[:current_year] = AwardYear.current.year
    render(assigns, "users/notify_non_shortlisted_mailer/notify")
  end

  def shortlisted_notifier
    assigns = {}
    assigns[:user] = dummy_user("Jon", "Doe", "John's Company")
    assigns[:form_answer] = form_answer
    assigns[:company_name] = "Massive Dynamic"

    assigns[:deadline] = deadline_str("audit_certificates")

    assigns[:award_type_full_name] = "Innovation"

    render(assigns, "users/notify_shortlisted_mailer/notify")
  end

  def winners_notification
    assigns = {}

    assigns[:token] = "secret"
    assigns[:form_answer] = form_answer
    assigns[:name] = "Jon Snow"
    assigns[:deadline] = deadline("buckingham_palace_attendees_details")
    assigns[:media_deadline] = deadline_str(
      "buckingham_palace_media_information",
      "%A %d %B %Y"
    )
    assigns[:book_notes_deadline] = deadline_str(
      "buckingham_palace_confirm_press_book_notes",
      "%l %p on %A %d %B"
    )
    assigns[:attendees_invite_date] = deadline_str(
      "buckingham_palace_attendees_invite",
      "%A %d %B %Y"
    )

    render(assigns, "users/buckingham_palace_invite_mailer/invite")
  end

  def winners_press_release_comments_request
    assigns = {}
    assigns[:user] = dummy_user("Jon", "Doe", "John's Company")
    assigns[:token] = "secret"
    assigns[:form_answer] = form_answer
    assigns[:deadline] = deadline_str("press_release_comments")

    render(assigns, "users/winners_press_release/notify")
  end

  private

  def render(assigns, template)
    view = View.new(ActionController::Base.view_paths, assigns)
    view.render(template: template)
  end

  def dummy_user(first_name, last_name, company_name)
    User.new(first_name: first_name, last_name: last_name, company_name: company_name).decorate
  end

  def form_answer
    @form_answer ||= FormAnswer.new(
      id: 0,
      urn: "QA0128/16I",
      award_type: "innovation",
      award_year: AwardYear.current,
      award_type_full_name: "Innovation"
    ).decorate
  end

  def deadline_str(kind, format = "%d/%m/%Y")
    d = deadline(kind)

    if d.present?
      d.strftime(format)
    else
      "21/09/#{Date.current.year}"
    end
  end

  def deadline(kind)
    Settings.current.deadlines.find_by(
      kind: kind
    ).try :trigger_at
  end
end
