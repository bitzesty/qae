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
    assigns[:company_name] = "Massive Dynamic"

    render(assigns, "users/shortlisted_unsuccessful_feedback_mailer/notify")
  end

  def ep_reminder_support_letters
    assigns = {}

    assigns[:user] = dummy_user("Jon", "Doe", "Jane's Company")
    assigns[:form_answer] = form_answer
    assigns[:days_before_submission] = "N"
    assigns[:deadline] = deadline("submission_end")
    assigns[:nominee_name] = "Jane Doe"

    render(assigns, "users/promotion_letters_of_support_reminder_mailer/notify")
  end

  def reminder_to_submit
    assigns = {}

    assigns[:user] = dummy_user("Jon", "Doe", "Jane's Company")
    assigns[:form_answer] = form_answer
    assigns[:days_before_submission] = "N"
    assigns[:deadline] = deadline("submission_end")

    render(assigns, "users/reminder_to_submit_mailer/notify")
  end

  def shortlisted_audit_certificate_reminder
    assigns = {}

    assigns[:recipient] = dummy_user("Jane", "Doe", "Jane's Company")
    assigns[:form_answer] = form_answer
    assigns[:deadline] = deadline("audit_certificates")

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

    assigns[:deadline] = deadline("audit_certificates")

    assigns[:award_type_full_name] = "Innovation"

    render(assigns, "users/notify_shortlisted_mailer/notify")
  end

  def winners_notification
    assigns = {}

    assigns[:token] = "secret"
    assigns[:form_answer] = form_answer
    assigns[:name] = "Jon Snow"
    assigns[:deadline] = deadline("buckingham_palace_attendees_details")

    render(assigns, "users/buckingham_palace_invite_mailer/invite")
  end

  def winners_press_release_comments_request
    assigns = {}
    assigns[:user] = dummy_user("Jon", "Doe", "John's Company")
    assigns[:token] = "secret"
    assigns[:form_answer] = form_answer
    assigns[:deadline] = deadline("press_release_comments")

    render(assigns, "users/winners_press_release/notify")
  end

  def all_unsuccessful_feedback
    assigns = {}
    assigns[:user] = dummy_user("Jon", "Doe", "John's Company")
    assigns[:form_answer] = form_answer
    assigns[:award_title] = assigns[:form_answer].award_application_title
    render(assigns, "users/unsuccessful_feedback_mailer/notify")
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
    f = FormAnswer.new(id: 0, award_type: "innovation").decorate
    f.award_year = AwardYear.current
    f
  end

  def deadline(kind)
    d = Settings.current.deadlines.where(kind: kind).first

    if d.trigger_at
      d.trigger_at.strftime("%d/%m/%Y")
    else
      "21/09/#{Date.current.year}"
    end
  end
end
