class Users::SupportersController < Users::BaseController
  expose(:form_answer) do
    current_user.account
                .form_answers
                .find(params[:form_answer_id])
  end
  expose(:supporter) do
    form_answer.supporters.new(
      supporter_params.merge({
        user_id: current_user.id,
      }),
    )
  end

  def create
    if supporter.save
      render json: supporter.id,
        status: :created
    else
      render json: supporter.errors.messages.to_json,
        status: :unprocessable_entity
    end
  end

  def destroy
    @supporter = form_answer.supporters.find(params[:id])
    @supporter.destroy
    head :ok
  end

  private

  def supporter_params
    params.require(:support_letter).permit(
      :first_name,
      :last_name,
      :relationship_to_nominee,
      :email,
    )
  end
end
