class Form::SupportersController < Form::BaseController
  def create
    @supporter = @form_answer.supporters.build(supporter_params)
    @supporter.user = current_user

    if @supporter.save
      redirect_to form_form_answer_supporters_path(@form_answer)
    else
      render :new
    end
  end

  def index
    @step = @form.steps.detect { |s| s.opts[:id] == :letters_of_support_step }
  end

  def new
    @supporter = @form_answer.supporters.build
  end

  def destroy
    @form_answer.supporters.find(params[:id])
    @form_answer.destroy

    redirect_to form_form_answer_supporters_path(@form_answer)
  end

  private

  def supporter_params
    params.require(:supporter).permit(
      :first_name,
      :last_name,
      :relationship_to_nominee,
      :email
    )
  end
end
