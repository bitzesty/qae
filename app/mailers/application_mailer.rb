class ApplicationMailer < ActionMailer::Base
  default from: ENV["MAILER_FROM"] || "no-reply@queens-awards-enterprise.service.gov.uk",
          reply_to: "queensawards@bis.gsi.gov.uk"
  layout "mailer"
end
