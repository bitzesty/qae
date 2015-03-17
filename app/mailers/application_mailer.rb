class ApplicationMailer < ActionMailer::Base
  default from: ENV["MAILER_FROM"] || "support@qae.co.uk"
end
