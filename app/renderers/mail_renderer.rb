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
  %w(reminder_to_submit ep_reminder_support_letters winners_notification winners_reminder_to_submit winners_press_release_comments_request unsuccessfull_notification all_unsuccessfull_feedback).each do |method|
    define_method method do
      "<b>TODO</b>".html_safe
    end
  end

  def shortlisted_audit_certificate_reminder
    assigns = {}

    assigns[:form_owner] = User.new(first_name: 'Jon', last_name: 'Doe').decorate
    assigns[:recipient] = User.new(first_name: 'Jane', last_name: 'Doe').decorate
    assigns[:form_answer] = FormAnswer.new(id: 0, user: assigns[:user], award_type: 'promotion').decorate
    assigns[:award_title] = assigns[:form_answer].award_application_title

    render(assigns, "users/audit_certificate_request_mailer/notify")
  end

  def not_shortlisted_notifier
    assigns = {}
    assigns[:user] = User.new(first_name: 'Jon', last_name: 'Doe').decorate
    render(assigns, "users/notify_non_shortlisted_mailer/notify")
  end

  def shortlisted_notifier
    assigns = {}
    assigns[:user] = User.new(first_name: 'Jon', last_name: 'Doe').decorate
    render(assigns, "users/notify_shortlisted_mailer/notify")
  end

  private

  def render(assigns, template)
    view = View.new(ActionController::Base.view_paths, assigns)
    view.render(template: template)
  end
end
