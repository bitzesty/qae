class Users::SupportLettersController < Users::BaseController
  expose(:form_answer) do
    current_user.account
                .form_answers
                .find(params[:form_answer_id])
  end
  expose(:support_letter) do
    form_answer.support_letters.new(
      support_letter_params.merge({
        user_id: current_user.id,
        manual: true,
        support_letter_attachment: attachment,
      }),
    )
  end
  expose(:attachment) do
    SupportLetterAttachment.find_by(id: support_letter_params[:attachment])
  end

  def create
    if support_letter.save
      attachment.support_letter = support_letter
      attachment.save!

      render json: support_letter.id,
        status: :created
    else
      render json: support_letter.errors.messages.to_json,
        status: :unprocessable_entity
    end
  end

  def show
    @support_letter = form_answer.support_letters.find(params[:id])
  end

  def destroy
    @support_letter = form_answer.support_letters.find(params[:id])
    @support_letter.destroy

    if request.xhr? || request.format.js?
      head :ok
    else
      flash[:notice] = "Support letter have been successfully destroyed"
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def support_letter_params
    params.require(:support_letter).permit(
      :first_name,
      :last_name,
      :relationship_to_nominee,
      :attachment,
    )
  end
end
