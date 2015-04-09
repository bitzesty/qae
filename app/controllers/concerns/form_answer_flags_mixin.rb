module FormAnswerFlagsMixin
  def toggle
    authorize :flag, :toggle?

    if assessor_flag.present?
      authorize form_answer, :toggle_assessor_flag?
      form_answer.assessor_importance_flag = assessor_flag
    end

    if admin_flag.present?
      authorize form_answer, :toggle_admin_flag?
      form_answer.admin_importance_flag = admin_flag
    end
    form_answer.save

    respond_to do |format|
      format.html { redirect_to [namespace_name, form_answer] }
      format.js { render json: {} }
    end
  end

  private

  def assessor_flag
    params[:assessor_importance_flag]
  end

  def admin_flag
    params[:admin_importance_flag]
  end

  def form_answer
    @form_answer ||= @award_year.form_answers.find(params[:form_answer_id])
  end
end
