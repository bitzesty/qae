class AccountMailer < ApplicationMailer
  default from: ENV["MAILER_FROM"] || "no-reply@queens-awards-enterprise.service.gov.uk",
          reply_to: "info@queensawards.org.uk",
          bcc: proc { form_answer.account.collaborators_without(form_answer.user).map(&:email) }
  layout "mailer"

  attr_reader :form_answer
end
