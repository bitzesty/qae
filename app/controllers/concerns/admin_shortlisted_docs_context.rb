module AdminShortlistedDocsContext
  def show
    authorize form_answer, :download_commercial_figures?
    file_record = form_answer.public_send(file_model_name).find(params[:id])

    send_data file_record.attachment.read,
              filename: file_record.attachment.file.filename,
              disposition: "attachment"
  end

  private

  def form_answer
    @form_answer ||= FormAnswer.find(params[:form_answer_id])
  end
end
