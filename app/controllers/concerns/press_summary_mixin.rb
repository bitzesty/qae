module PressSummaryMixin
  extend ActiveSupport::Concern

  def self.included(base)
    base.before_action :load_form_answer
    base.before_action :load_press_summary, except: :create
  end

  def create
    @press_summary = @form_answer.build_press_summary(press_summary_params)
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
    params.require(:press_summary).permit(:body, :name, :phone_number, :email)
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
          render json: { errors: [] }
        else
          render status: :unprocessable_entity,
                 json: { errors: @press_summary.resource.errors }
        end
      end
    end
  end
end
