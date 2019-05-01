class ApplicationMailer < Mail::Notify::Mailer
  default from: ENV["MAILER_FROM"] || "no-reply@queens-awards-enterprise.service.gov.uk",
          reply_to: "queensawards@beis.gov.uk"
  layout "mailer"

  def mail(headers = {}, &block)
    return true if ::CheckAccountOnBouncesEmail.bounces_email?(headers[:to])

    super(headers, &block)
  end
end
