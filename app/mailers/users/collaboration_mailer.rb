class Users::CollaborationMailer < ActionMailer::Base
  default from: "support@qae.co.uk"

  def access_granted(user_who_added, collaborator)
    @user_who_added = user_who_added.decorate
    @collaborator = collaborator

    @subject = "[Queen's Awards for Enterprise] #{@user_who_added.full_name} added you to collaborators!"

    mail to: @collaborator.email, subject: @subject
  end
end