class Form::SubsidiariesController < Form::NonJsDynamicListsFormSectionController
  # This controller handles saving of Subsidiaries on Trade Form
  # This section is used in case if JS disabled

  expose(:step_name) do
    "Company information"
  end

  expose(:input_name) do
    "trading_figures_add"
  end

  expose(:section_folder_name) do
    "subsidiaries"
  end

  expose(:item_name) do
    "subsidiary, associate or plant"
  end

  expose(:item_class) do
    Subsidiary
  end

  expose(:item) do
    item_class.new
  end

  expose(:created_item_ops) do
    {
      "name" => item_params[:name],
      "location" => item_params[:location],
      "employees" => item_params[:employees],
      "description" => item_params[:description],
    }
  end

  expose(:delete_item_url) do
    form_form_answer_subsidiaries_url(
      @form_answer.id,
      subsidiary: {
        name: item.name,
        location: item.location,
      },
    )
  end

  def new; end

  def create
    self.item = item_class.new(item_params)

    if item.valid?
      @form_answer.document = add_result_doc
      @form_answer.save

      redirect_to edit_form_url(
        id: @form_answer.id,
        anchor: anchor,
      )
    else
      render :new
    end
  end

  def confirm_deletion
    self.item = item_class.new(item_params)
  end

  def destroy
    @form_answer.document = remove_result_doc
    @form_answer.save

    redirect_to edit_form_url(
      id: @form_answer.id,
      anchor: anchor,
    )
  end

  def edit
    self.item = item_class.new(item_params)
  end

  def update
    self.item = item_class.new(item_params)

    if item.valid?
      @form_answer.document = update_result_doc
      @form_answer.save

      redirect_to edit_form_url(
        id: @form_answer.id,
        anchor: anchor,
      )
    else
      render :edit
    end
  end

  def item_detect_condition(el, attrs = nil)
    el["name"] == (attrs.present? ? attrs[:name] : ops_hash[:name]) &&
      el["location"] == (attrs.present? ? attrs[:location] : ops_hash[:location])
  end

  private

  def item_params
    params.require(:subsidiary).permit(
      :name,
      :location,
      :employees,
      :description,
    )
  end
end
