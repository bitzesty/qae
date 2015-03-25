module PressSummaryMixin
  extend ActiveSupport::Concern

  def self.included(base)
    base.before_action :load_form_answer
    base.before_action :load_press_summary, except: :create
  end

  def create
    @press_summary = @form_answer.build_press_summary(press_summary_params)
    authorize @press_summary, :create?

    @press_summary.save

    render_create
  end

  def update
    authorize @press_summary, :update?

    @press_summary.update_attributes(press_summary_params)

    render_create
  end

  def approve
    authorize @press_summary, :approve?
    @press_summary.approved = true
    @press_summary.save

    respond_to do |format|
      format.html do
        flash.notice = "Press Summary was successfully approved"
        redirect_to [namespace_name, @form_answer]
      end

      format.js { render "admin/press_summaries/create" }
    end
  end

  private

  def press_summary_params
    params.require(:press_summary).permit(:body)
  end

  def load_form_answer
    @form_answer = form_answers_scope.find(params[:form_answer_id]).decorate
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

      format.js { render "admin/press_summaries/create" }
    end
  end
end
