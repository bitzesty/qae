class Admin::FlagsController < Admin::BaseController
  def toggle
    form_answer.toggle_importance_flag
    authorize :flag, :toggle?
    respond_to do |format|
      format.html{ redirect_to admin_form_answer_path(form_answer) }
      format.js{ render json: {}}
    end
  end

  private

  def form_answer
    @form_answer ||= FormAnswer.find(params[:form_answer_id])
  end
end
