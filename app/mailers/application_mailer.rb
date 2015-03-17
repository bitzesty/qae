class ApplicationMailer < ActionMailer::Base
  default from: ENV["MAILER_FROM"] || "no-reply@qae.direct.gov.uk"
end
