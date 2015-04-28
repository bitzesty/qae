class Form::CurrentQueensAwardsController < Form::NonJsDynamicListsFormSectionController

  # This controller handles saving of CurrentQueensAwards
  # This section is used in case if JS disabled

  expose(:step_name) do
    "Company Information"
  end

  expose(:input_name) do
    "queen_award_holder_details"
  end

  expose(:section_folder_name) do
    "current_queens_awards"
  end

  expose(:item_name) do
    "Award"
  end

  expose(:categories) do
    question.categories
  end

  expose(:years) do
    question.years
  end

  expose(:item_class) do
    CurrentQueensAward
  end

  expose(:item) do
    item_class.new(categories, years, {})
  end

  expose(:created_item_ops) do
    {
      "category" => item_params[:category],
      "year" => item_params[:year]
    }
  end

  def new
  end

  def create
    self.item = item_class.new(categories,
                               years,
                               item_params)

    if item.valid?
      @form_answer.document = add_result_doc
      @form_answer.save

      redirect_to edit_form_url(
        id: @form_answer.id,
        anchor: "non_js_#{input_name}-list-question"
      )
    else
      render :new
    end
  end

  def confirm_deletion
    self.item = item_class.new(categories,
                               years,
                               item_params)
  end

  def destroy
    @form_answer.document = remove_result_doc
    @form_answer.save

    redirect_to edit_form_url(
      id: @form_answer.id,
      anchor: "non_js_#{input_name}-list-question"
    )
  end

  def edit
    self.item = item_class.new(categories,
                               years,
                               item_params)
  end

  def update
    self.item = item_class.new(categories,
                               years,
                               item_params)

    if item.valid?
      @form_answer.document = update_result_doc
      @form_answer.save

      redirect_to edit_form_url(
        id: @form_answer.id,
        anchor: "non_js_#{input_name}-list-question"
      )
    else
      render :edit
    end
  end

  def item_detect_condition(el, attrs=nil)
    el["category"] == (attrs.present? ? attrs[:category] : ops_hash[:category]) &&
    el["year"] == (attrs.present? ? attrs[:year] : ops_hash[:year])
  end

  private

  def item_params
    params.require(:current_queens_award).permit(
      :category,
      :year
    )
  end
end
