class AccountMailers::BaseMailer < ApplicationMailer
  default from: ENV["MAILER_FROM"] || "no-reply@kings-awards-enterprise.service.gov.uk",
    reply_to: "kingsawards@businessandtrade.gov.uk"

  layout "mailer"

  attr_reader :form_answer
end
