class ApplicationMailer < ActionMailer::Base
  default from: ENV["MAILER_FROM"] || "info@queensawards.org.uk"
  layout "mailer"
end
