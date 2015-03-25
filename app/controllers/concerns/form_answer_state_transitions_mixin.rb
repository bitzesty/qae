module FormAnswerStateTransitionsMixin
  def create
    @form_answer_state_transition = FormAnswerStateTransition.new(create_params)
    @form_answer_state_transition.form_answer = form_answer
    @form_answer_state_transition.subject = current_subject

    authorize @form_answer_state_transition, :create?

    @form_answer_state_transition.save

    respond_to do |format|
      format.html do
        redirect_to [namespace_name, form_answer]
      end

      format.json
    end
  end

  private

  def form_answer
    @form_answer ||= FormAnswer.find(params[:form_answer_id])
  end

  def create_params
    params.require(:form_answer_state_transition).permit(:state)
  end
end
