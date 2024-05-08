class Form::SupportersController < Form::BaseController
  def create
    @supporter = @form_answer.supporters.build(supporter_params)
    @supporter.user = current_user

    if @supporter.save
      add_supporter_to_document!
      @form_answer.save

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
    @supporter = @form_answer.supporters.find(params[:id])

    if @supporter.destroy
      remove_supporter_from_document!
      @form_answer.save
    end

    redirect_to form_form_answer_supporters_path(@form_answer)
  end

  private

  def add_supporter_to_document!
    supporters = supporters_doc

    new_supporter = {
      supporter_id: @supporter.id,
      first_name: @supporter.first_name,
      last_name: @supporter.last_name,
      relationship_to_nominee: @supporter.relationship_to_nominee,
      email: @supporter.email,
    }

    supporters << new_supporter

    @form_answer.document = @form_answer.document.merge(supporters: supporters)
  end

  def remove_supporter_from_document!
    supporters = supporters_doc

    supporters.delete_if do |sup|
      sup["supporter_id"] == @supporter.id
    end

    @form_answer.document = @form_answer.document.merge(supporters: supporters)
  end

  def supporters_doc
    if @form_answer.document["supporters"].present?
      @form_answer.document["supporters"]
    else
      []
    end
  end

  def supporter_params
    params.require(:supporter).permit(
      :first_name,
      :last_name,
      :relationship_to_nominee,
      :email,
    )
  end
end
