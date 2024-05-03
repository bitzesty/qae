class Users::FormAnswerFeedbacksController < Users::BaseController
  #
  # So devise can't handle redirect to new user session path
  # on using pdf format
  # related topic
  # http://stackoverflow.com/questions/7996773/devise-authentication-when-accessing-directly-to-a-pdf-file-unauthenticated
  #
  # so that we had to skip standart authenticate_user! filter
  # and use own handler
  #

  skip_before_action :authenticate_user!, raise: false
  before_action :require_logged_in_user!

  before_action :require_application_to_have_a_feedback!

  def show
    respond_to do |format|
      format.pdf do
        pdf = form_answer.feedbacks_pdf_generator
        send_data pdf.render,
                  filename: "application_feedback_#{form_answer.pdf_filename}",
                  type: "application/pdf",
                  disposition: "attachment"
      end
    end
  end

  private

  def form_answer
    @form_answer ||= current_account.form_answers.find(params[:id]).decorate
  end

  def require_logged_in_user!
    return if user_signed_in?

    session[:custom_redirect] = users_form_answer_feedback_url(params[:id], format: :pdf)
    redirect_to new_user_session_url

    false
  end

  def require_application_to_have_a_feedback!
    return if form_answer.feedback.present?

    redirect_to dashboard_url,
                notice: "There are no any feedback for this application!"
    false
  end
end
