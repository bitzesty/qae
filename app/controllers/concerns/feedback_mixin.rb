module FeedbackMixin
  extend ActiveSupport::Concern

  def self.included(base)
    base.before_action :load_form_answer
    base.before_action :load_feedback, except: :create
  end

  def create
    @feedback = @form_answer.build_feedback(feedback_params)
    authorize @feedback, :create?

    @feedback.save

    respond_to do |format|
      format.html do
        if @feedback.valid?
          flash.notice = "Feedback was successfully updated"
        else
          flash.alert = "Feedback was not updated"
        end

        redirect_to [namespace_name, @form_answer]
      end

      format.js { render "admin/feedbacks/create" }
    end
  end

  def update
    authorize @feedback, :update?

    @feedback.update_attributes(feedback_params)

    respond_to do |format|
      format.html do
        if @feedback.valid?
          flash.notice = "Feedback was successfully updated"
        else
          flash.alert = "Feedback was not updated"
        end

        redirect_to [namespace_name, @form_answer]
      end

      format.js { render "admin/feedbacks/create" }
    end
  end

  def submit
    authorize @feedback, :submit?
    @feedback.submitted = true
    @feedback.save

    respond_to do |format|
      format.html do
        flash.notice = "Feedback was successfully submitted"
        redirect_to [namespace_name, @form_answer]
      end

      format.js { render "admin/feedbacks/create" }
    end
  end

  def approve
    authorize @feedback, :approve?
    @feedback.approved = true
    @feedback.save

    respond_to do |format|
      format.html do
        flash.notice = "Feedback was successfully approved"
        redirect_to [namespace_name, @form_answer]
      end

      format.js { render "admin/feedbacks/create" }
    end
  end

  private

  def load_form_answer
    @form_answer = form_answers_scope.find(params[:form_answer_id]).decorate
  end

  def form_answers_scope
    FormAnswer
  end

  def feedback_params
    params.require(:feedback).permit(FeedbackForm.fields)
  end

  def load_feedback
    @feedback = @form_answer.feedback
  end
end
