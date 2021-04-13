module ListOfProceduresContext
  def show
    authorize form_answer, :download_list_of_procedures_pdf?
    redirect_to resource.attachment_url
  end

  private

  def resource
    @list_of_procedure ||= form_answer.list_of_procedure
  end

  def form_answer
    @form_answer ||= FormAnswer.find(params[:form_answer_id])
  end
end
