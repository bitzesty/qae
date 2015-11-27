module ReviewCorpResponsibilityMixin
  def create
    authorize form_answer, :can_review_corp_responsibility?

    # form_answer.update_column(:corp_responsibility_submitted, true)

    respond_to do |format|
      format.js { render(nothing: true) }
      format.html do
        redirect_to [namespace_name, form_answer]
      end
    end
  end
end
