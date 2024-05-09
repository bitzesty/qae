class Form::PositionsController < Form::NonJsDynamicListsFormSectionController
  # This controller handles saving / removing of Position Details on EP Form
  # This section is used in case if JS disabled

  expose(:step) do
    @form.steps.detect { |s| s.opts[:id] == :position_details_step }
  end

  expose(:input_name) do
    "position_details"
  end

  expose(:section_folder_name) do
    "positions"
  end

  expose(:item_name) do
    "Role"
  end

  expose(:item_class) do
    Position
  end

  expose(:item) do
    item_class.new
  end

  expose(:created_item_ops) do
    {
      "name" => item_params[:name],
      "details" => item_params[:details],
      "ongoing" => item_params[:ongoing],
      "start_month" => item_params[:start_month],
      "start_year" => item_params[:start_year],
      "end_month" => item_params[:end_month],
      "end_year" => item_params[:end_year],
    }
  end

  def index
  end

  def new
  end

  def create
    self.item = item_class.new(item_params)

    if item.valid?
      @form_answer.document = add_result_doc
      @form_answer.save

      redirect_to form_form_answer_positions_url(@form_answer)
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

    redirect_to form_form_answer_positions_url(@form_answer)
  end

  def edit
    Rails.logger.info "[item_params] #{item_params.inspect}"
    self.item = item_class.new(item_params)
  end

  def update
    self.item = item_class.new(item_params)

    if item.valid?
      @form_answer.document = update_result_doc
      @form_answer.save

      redirect_to form_form_answer_positions_url(@form_answer)
    else
      render :edit
    end
  end

  def item_detect_condition(el, attrs = nil)
    el["name"] == (attrs.present? ? attrs[:name] : ops_hash[:name]) &&
      el["start_month"] == (attrs.present? ? attrs[:start_month] : ops_hash[:start_month]) &&
      el["start_year"] == (attrs.present? ? attrs[:start_year] : ops_hash[:start_year])
  end

  private

  def item_params
    params.require(:position).permit(
      :name,
      :details,
      :ongoing,
      :start_month,
      :start_year,
      :end_month,
      :end_year,
    )
  end
end
