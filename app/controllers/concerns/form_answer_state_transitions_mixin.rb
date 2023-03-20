module FormAnswerStateTransitionsMixin
  def create
    @form_answer_state_transition = FormAnswerStateTransition.new(create_params)
    @form_answer_state_transition.form_answer = form_answer
    @form_answer_state_transition.subject = current_subject

    authorize @form_answer_state_transition, :create?

    @form_answer_state_transition.save

    respond_to do |format|
      format.html do
        if request.xhr? || request.format.js?
          render partial: "admin/form_answers/states_list",
                 locals: { collection: @form_answer_state_transition.collection, policy: policy(@form_answer_state_transition).view_dropdown? }
        else
          redirect_to [namespace_name, form_answer]
        end
      end
    end
  end

  private

  def form_answer
    @form_answer ||= @award_year.form_answers.find(params[:form_answer_id])
  end

  def create_params
    params.require(:form_answer_state_transition).permit(:state)
  end
end
