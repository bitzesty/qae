class Form::AwardsController < Form::NonJsDynamicListsFormSectionController
  # This controller handles saving of Awards
  # This section is used in case if JS disabled

  expose(:step_name) do
    "Nominee"
  end

  expose(:input_name) do
    params[:holder].present? ? "awards" : "nomination_awards"
  end

  expose(:section_folder_name) do
    "awards"
  end

  expose(:item_name) do
    "Award/Personal honour"
  end

  expose(:item_class) do
    Award
  end

  expose(:item) do
    item_class.new(question, params[:holder], {})
  end

  expose(:created_item_ops) do
    attrs = {
      "title" => item_params[:title],
      "details" => item_params[:details],
    }

    attrs["year"] = item_params[:year] if params[:holder].present?
    attrs
  end

  expose(:delete_item_url) do
    form_form_answer_awards_url(
      @form_answer.id,
      award: created_item_ops,
      holder: params[:holder],
    )
  end

  def new
  end

  def create
    self.item = item_class.new(question,
      params[:holder],
      item_params,)

    if item.valid?
      @form_answer.document = add_result_doc
      @form_answer.save

      redirect_to edit_form_url(
        id: @form_answer.id,
        step: step.title.parameterize,
        anchor: anchor,
      )
    else
      render :new
    end
  end

  def confirm_deletion
    self.item = item_class.new(question,
      params[:holder],
      item_params,)
  end

  def destroy
    @form_answer.document = remove_result_doc
    @form_answer.save

    redirect_to edit_form_url(
      id: @form_answer.id,
      step: step.title.parameterize,
      anchor: anchor,
    )
  end

  def edit
    self.item = item_class.new(question,
      params[:holder],
      item_params,)
  end

  def update
    self.item = item_class.new(question,
      params[:holder],
      item_params,)

    if item.valid?
      @form_answer.document = update_result_doc
      @form_answer.save

      redirect_to edit_form_url(
        id: @form_answer.id,
        step: step.title.parameterize,
        anchor: anchor,
      )
    else
      render :edit
    end
  end

  def item_detect_condition(el, attrs=nil)
    if params[:holder].present?
      el["title"] == (attrs.present? ? attrs[:title] : ops_hash[:title]) &&
        el["year"] == (attrs.present? ? attrs[:year] : ops_hash[:year])
    else
      el["title"] == (attrs.present? ? attrs[:title] : ops_hash[:title])
    end
  end

  private

  def item_params
    params.require(:award).permit(
      :title,
      :year,
      :details,
    )
  end
end
