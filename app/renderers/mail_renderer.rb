class MailRenderer
  class View < ActionView::Base
    extend ApplicationHelper
    include ActionView::Helpers
    include Rails.application.routes.url_helpers

    def default_url_options
      { host: "queens-awards-enterprise.service.gov.uk" }
    end
  end

  # this will be removed after all methods are implemented
  %w(reminder_to_submit ep_reminder_support_letters winners_notification winners_reminder_to_submit unsuccessful_notification).each do |method|
    define_method method do
      "<b>TODO</b>".html_safe
    end
  end

  def shortlisted_audit_certificate_reminder
    assigns = {}

    assigns[:form_owner] = dummy_user("Jon", "Doe")
    assigns[:recipient] = dummy_user("Jane", "Doe")
    assigns[:form_answer] = form_answer
    assigns[:award_title] = assigns[:form_answer].award_application_title

    render(assigns, "users/audit_certificate_request_mailer/notify")
  end

  def not_shortlisted_notifier
    assigns = {}
    assigns[:user] = dummy_user("Jon", "Doe")
    render(assigns, "users/notify_non_shortlisted_mailer/notify")
  end

  def shortlisted_notifier
    assigns = {}
    assigns[:user] = dummy_user("Jon", "Doe")
    render(assigns, "users/notify_shortlisted_mailer/notify")
  end

  def winners_notification
    assigns = {}

    assigns[:token] = "secret"
    render(assigns, "users/buckingham_palace_invite_mailer/invite")
  end

  def winners_press_release_comments_request
    assigns = {}
    assigns[:user] = dummy_user("Jon", "Doe")
    assigns[:token] = "secret"
    assigns[:form_answer] = form_answer
    render(assigns, "users/winners_press_release/notify")
  end

  def all_unsuccessful_feedback
    assigns = {}
    assigns[:user] = dummy_user("Jon", "Doe")
    assigns[:form_answer] = form_answer
    render(assigns, "users/unsuccessful_feedback_mailer/notify")
  end

  private

  def render(assigns, template)
    view = View.new(ActionController::Base.view_paths, assigns)
    view.render(template: template)
  end

  def dummy_user(first_name, last_name)
    User.new(first_name: first_name, last_name: last_name).decorate
  end

  def form_answer
    FormAnswer.new(id: 0, award_type: "promotion").decorate
  end
end
