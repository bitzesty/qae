class ApplicationMailer < Mail::Notify::Mailer
  include MailerHelper

  default from: ENV["MAILER_FROM"] || "no-reply@kings-awards-enterprise.service.gov.uk",
          reply_to: "kingsawards@beis.gov.uk"

  def send_mail_if_not_bounces(template_id, headers)
    return true if ::CheckAccountOnBouncesEmail.bounces_email?(headers[:to])

    view_mail(template_id, headers)
  end

  def subject_with_env_prefix(subject_str)
    if ::ServerEnvironment.local_or_dev_or_staging_server?
      "#{::ServerEnvironment.env_prefix_in_mailers} #{subject_str}"
    else
      subject_str
    end
  end
end
