class Users::SupportLettersController < Users::BaseController
  expose(:form_answer) do
    current_user.account.
                form_answers.
                find(params[:form_answer_id])
  end
  expose(:support_letter) do
    form_answer.support_letters.new(
      support_letter_params.merge({
        user_id: current_user.id
      })
    )
  end
  expose(:attachment) do
    SupportLetterAttachment.find(support_letter_params[:attachment])
  end

  def create
    Rails.logger.info "[support_letter] #{support_letter.inspect}"

    if support_letter.save
      attachment.support_letter = support_letter
      attachment.save!

      render json: support_letter,
             status: :created
    else
      render json: humanized_errors,
             status: :unprocessable_entity
    end
  end

  private

    def support_letter_params
      params.require(:support_letter).permit(
        :first_name,
        :last_name,
        :relationship_to_nominee,
        :attachment
      )
    end

    def humanized_errors
      support_letter.errors.
                    full_messages.
                    join(", ")
    end
end
