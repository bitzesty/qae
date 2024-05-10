module ReviewCommercialFiguresMixin
  def create
    @form = ShortlistedDocumentsReviewForm.new(create_params)
    @form.subject = current_subject

    authorize @form.form_answer, :review_commercial_figures?

    @form.save

    respond_to do |format|
      format.js { head :ok }
      format.html do
        redirect_to [namespace_name, @form.form_answer]
      end
    end
  end

  private

  def create_params
    params.require(:shortlisted_documents_review_form).permit(
      :changes_description,
      :form_answer_id,
      :status,
    )
  end
end
