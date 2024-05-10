module FeedbackMixin
  extend ActiveSupport::Concern

  def self.included(base)
    base.before_action :load_form_answer
    base.before_action :load_feedback, except: :create
  end

  def create
    @feedback = if @form_answer.feedback.present?
      # Looks bit ugly
      # but hopefully will prevent duplicates creation
      #
      f = @form_answer.feedback
      f.assign_attributes(feedback_params)
      f
    else
      @form_answer.build_feedback(feedback_params)
    end

    authorize @feedback, :create?
    @feedback.authorable = current_subject
    log_event if @feedback.save

    render_create
  end

  def update
    authorize @feedback, :update?

    @feedback.assign_attributes(feedback_params)
    @feedback.authorable = current_subject
    log_event if @feedback.save

    render_create
  end

  def submit
    authorize @feedback, :submit?
    @feedback.submitted = true
    @feedback.authorable = current_subject
    @feedback.locked_at = Time.zone.now

    save_and_render_submit("submitted")
  end

  def unlock
    authorize @feedback, :unlock?
    @feedback.locked_at = nil
    save_and_render_submit("unlocked")
  end

  private

  def action_type
    (action_name == "unlock") ? "feedback_unsubmit" : "feedback_#{action_name}"
  end

  def form_answer
    load_form_answer
  end

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

      format.json do
        if @feedback.valid?
          render json: { errors: [] }
        else
          render status: :unprocessable_entity,
            json: { errors: @feedback.resource.errors }
        end
      end
    end
  end

  def save_and_render_submit(action)
    log_event if @feedback.save

    respond_to do |format|
      format.html do
        flash.notice = "Feedback was successfully #{action}"
        redirect_to [namespace_name, @form_answer]
      end

      format.js { render "admin/feedbacks/create" }
    end
  end
end
