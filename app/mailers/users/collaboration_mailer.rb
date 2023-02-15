class Users::CollaborationMailer < ApplicationMailer
  def access_granted(user_who_added, collaborator, new_user=false, generated_password=nil, devise_confirmation_token=nil)
    @user_who_added = user_who_added.decorate
    @collaborator = collaborator
    @new_user = new_user
    @generated_password = generated_password
    @devise_confirmation_token = devise_confirmation_token

    @subject = "[King's Awards for Enterprise] #{@user_who_added.full_name} added you to collaborators!"

    send_mail_if_not_bounces ENV['GOV_UK_NOTIFY_API_TEMPLATE_ID'], to: @collaborator.email, subject: subject_with_env_prefix(@subject)
  end
end
