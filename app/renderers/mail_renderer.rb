class MailRenderer
  class View < ActionView::Base
    extend ApplicationHelper
    include ActionView::Helpers
    include Rails.application.routes.url_helpers

    def default_url_options
      { host: "queens-awards-enterprise.service.gov.uk" }
    end
  end


  def shortlisted_audit_certificate_reminder
    assigns = {}

    assigns[:form_owner] = User.new(first_name: 'Jon', last_name: 'Doe').decorate
    assigns[:recipient] = User.new(first_name: 'Jane', last_name: 'Doe').decorate
    assigns[:form_answer] = FormAnswer.new(id: 0, user: assigns[:user], award_type: 'promotion').decorate
    assigns[:award_title] = assigns[:form_answer].award_application_title

    view = View.new(ActionController::Base.view_paths, assigns)
    view.render(template: "users/audit_certificate_request_mailer/notify")
  end
end
