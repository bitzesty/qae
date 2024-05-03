module PressSummaryMixin
  extend ActiveSupport::Concern

  def self.included(base)
    base.before_action :load_form_answer
    base.before_action :load_press_summary, except: :create
    base.after_action :log_event, only: %i[create update submit signoff]
  end

  def create
    if @form_answer.press_summary.present?
      @press_summary = @form_answer.press_summary
      @press_summary.attributes = press_summary_params
    else
      @press_summary = @form_answer.build_press_summary(press_summary_params)
    end

    authorize @press_summary, :create?

    @press_summary.authorable = current_subject
    @press_summary.save

    render_create
  end

  def update
    authorize @press_summary, :update?

    @press_summary.assign_attributes(press_summary_params)
    @press_summary.authorable = current_subject
    @press_summary.save

    render_create
  end

  def approve
    authorize @press_summary, :approve?
    @press_summary.approved = true
    change_state "Press Summary was successfully approved"
  end

  def submit
    authorize @press_summary, :submit?
    @press_summary.submitted = true
    change_state "Press Summary was successfully submitted"
  end

  def unlock
    authorize @press_summary, :unlock?
    @press_summary.submitted = false
    change_state "Press Summary was successfully unlocked"
  end

  def signoff
    authorize @press_summary, :admin_signoff?
    @press_summary.admin_sign_off = true
    change_state "Press Summary was successfully submitted"
  end

  private

  def form_answer
    load_form_answer
  end

  def action_type
    "press_summary_#{action_name}"
  end

  def change_state(message)
    @press_summary.save!

    respond_to do |format|
      format.html do
        flash.notice = message
        redirect_to [namespace_name, @form_answer]
      end

      format.js { render "admin/press_summaries/create" }
    end
  end

  def press_summary_params
    params.require(:press_summary).permit(
      :body,
      :title,
      :name,
      :last_name,
      :phone_number,
      :email,
      :contact_details_update,
      :body_update,
    )
  end

  def load_form_answer
    @form_answer = FormAnswer.find(params[:form_answer_id]).decorate
  end

  def load_press_summary
    @press_summary = @form_answer.press_summary
  end

  def render_create
    respond_to do |format|
      format.html do
        if @press_summary.valid?
          flash.notice = "Press Summary was successfully updated"
        else
          flash.alert = "Press Summary was not updated"
        end

        redirect_to [namespace_name, @form_answer]
      end

      format.js do
        if @press_summary.valid?
          render "shared/press_summaries/create"
        else
          render status: :unprocessable_entity,
                 json: { errors: @press_summary.errors.full_messages }
        end
      end
    end
  end
end
