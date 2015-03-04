class Users::SupportLetterAttachmentsController < Users::BaseController
  expose(:form_answer) do
    current_user.account.
                form_answers.
                find(params[:form_answer_id])
  end

  expose(:support_letter_attachment) do
    form_answer.support_letter_attachments.new(
      support_letter_attachment_params.merge({
        user_id: current_user.id,
        original_filename: original_filename
      })
    )
  end

  def create
    support_letter_attachment.save!
    render json: support_letter_attachment, status: :created
  end

  private

    def support_letter_attachment_params
      {
        attachment: params[:form][:supporter_letters_list].first[1][:letter_of_support]
      }
    end

    def original_filename
      support_letter_attachment_params[:attachment].try(:original_filename)
    end
end
