class Form::SupportLettersController < Form::BaseController
  before_action :load_letter, only: :destroy

  def create
    @support_letter = @form_answer.support_letters.new(
      support_letter_params.merge({
        user_id: current_user.id,
        manual: true
      })
    )

    attachment = SupportLetterAttachment.new(attachment_params)
    attachment.user = current_user
    attachment.form_answer = @form_answer
    @support_letter.support_letter_attachment = attachment

    if @support_letter.save
      redirect_to form_form_answer_supporters_path(@form_answer)
    else
      render :new
    end
  end

  def new
    @support_letter = @form_answer.support_letters.new
  end

  def destroy
    @support_letter.destroy
    redirect_to form_form_answer_supporters_path(@form_answer)
  end

  private

  def support_letter_params
    params[:support_letter].permit(
      :first_name,
      :last_name,
      :relationship_to_nominee
    )
  end

  def attachment_params
    if params[:support_letter] && params[:support_letter][:support_letter_attachment]
      params[:support_letter][:support_letter_attachment].permit(:attachment)
    else
      {}
    end
  end

  def load_letter
    @support_letter = @form_answer.support_letters.find(params[:id])
  end
end
