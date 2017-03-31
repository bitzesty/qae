class Users::CloudflareMailer < ApplicationMailer
  def notify(email)
    body = <<-TEXT
Hi,

We apologise if you are having issues accessing your account to review your feedback. We are currently experiencing some technical difficulties. Please try again later.

Thank you,

The Queen's Awards Office
    TEXT

    subject = "Technical difficulties"

    mail to: email, subject: subject, body: body
  end
end
