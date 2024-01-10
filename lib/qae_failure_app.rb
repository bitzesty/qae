class QaeFailureApp < Devise::FailureApp
  def respond
    if request.format == :pdf
      pdf_redirect
    else
      super
    end
  end

  def recall
    controller, action = warden_options[:recall].split("#")

    flash[:alert] = i18n_message(:invalid)
    redirect_to action: action, controller: controller
  end

  protected

  def pdf_redirect
    session["#{scope}_return_to"] = attempted_path if request.get?

    redirect_to :"new_#{scope}_session", format: :html, alert: i18n_message
  end
end
