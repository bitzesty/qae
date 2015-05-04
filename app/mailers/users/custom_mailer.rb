require "rails_autolink"

class Users::CustomMailer < ApplicationMailer
  include ActionView::Helpers::TextHelper

  def notify(email, body, subject)
    @body = auto_link(body)

    mail to: email, subject: subject
  end
end
