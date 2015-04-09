module SupportLettersContext
  def show
    authorize resource, :show?
    send_data support_letter_attachment.attachment.read,
              filename: support_letter_attachment.original_filename,
              disposition: "inline"
  end

  private

  def resource
    @support_letter ||= form_answer.support_letters.find(params[:id])
  end

  def form_answer
    @form_answer ||= @award_year.form_answers.find(params[:form_answer_id])
  end

  def support_letter_attachment
    resource.support_letter_attachment
  end
end
