module FeedbackMixin
  extend ActiveSupport::Concern

  def self.included(base)
    base.before_action :load_form_answer
    base.before_action :load_feedback, except: :create
  end

  def create
    @feedback = @form_answer.build_feedback(feedback_params)
    authorize @feedback, :create?
    @feedback.authorable = current_subject
    @feedback.save

    render_create
  end

  def update
    authorize @feedback, :update?

    @feedback.assign_attributes(feedback_params)
    @feedback.authorable = current_subject
    @feedback.save

    render_create
  end

  def submit
    authorize @feedback, :submit?
    @feedback.submitted = true
    save_and_render_submit("submitted")
  end

  def approve
    authorize @feedback, :approve?
    @feedback.approved = true
    save_and_render_submit("approved")
  end

  private

  def load_form_answer
    @form_answer = FormAnswer.find(params[:form_answer_id]).decorate
  end

  def feedback_params
    params.require(:feedback).permit(FeedbackForm.fields)
  end

  def load_feedback
    @feedback = @form_answer.feedback
  end

  def render_create
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

  def save_and_render_submit(action)
    @feedback.save

    respond_to do |format|
      format.html do
        flash.notice = "Feedback was successfully #{action}"
        redirect_to [namespace_name, @form_answer]
      end

      format.js { render "admin/feedbacks/create" }
    end
  end
end
