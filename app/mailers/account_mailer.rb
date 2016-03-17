class AccountMailer < ApplicationMailer
  default from: ENV["MAILER_FROM"] || "no-reply@queens-awards-enterprise.service.gov.uk",
          reply_to: "queensawards@bis.gsi.gov.uk",
          bcc: proc { form_answer.account.collaborators_without(form_answer.user).confirmed.map(&:email) }
  layout "mailer"

  attr_reader :form_answer
end
