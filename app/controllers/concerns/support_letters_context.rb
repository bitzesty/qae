module SupportLettersContext
  def show
    authorize resource, :show?

    if support_letter_attachment.present?
      send_data support_letter_attachment.attachment.read,
        filename: support_letter_attachment.original_filename,
        disposition: "attachment"
      nil
    else
      render "admin/support_letters/show"
    end
  end

  private

  def resource
    @support_letter ||= form_answer.support_letters.find(params[:id])
  end

  def form_answer
    @form_answer ||= FormAnswer.find(params[:form_answer_id])
  end

  def support_letter_attachment
    resource.support_letter_attachment
  end
end
