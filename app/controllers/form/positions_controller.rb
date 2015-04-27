class Form::PositionsController < Form::BaseController

  # This controller handles saving / removing of Position Details on EP Form
  # This section is used in case if JS disabled

  expose(:step) do
    @form.steps.detect { |s| s.opts[:id] == :position_details_step }
  end

  expose(:position_details_doc) do
    @form_answer.document["position_details"]
  end

  expose(:existing_position_details) do
    if position_details_doc.present?
      JSON.parse(position_details_doc).map do |el|
        JSON.parse(el)
      end
    else
      []
    end
  end

  expose(:position) do
    Position.new
  end

  expose(:created_position_ops) do
    {
      "name" => position_params[:name],
      "details" => position_params[:details],
      "ongoing" => position_params[:ongoing],
      "start_month" => position_params[:start_month],
      "start_year" => position_params[:start_year],
      "end_month" => position_params[:end_month],
      "end_year" => position_params[:end_year]
    }
  end

  expose(:add_position_result_doc) do
    result_position_details = existing_position_details
    result_position_details.push(created_position_ops)
    result_position_details = result_position_details.map(&:to_json)

    @form_answer.document.merge(
      position_details: result_position_details.to_json
    )
  end

  expose(:remove_position_result_doc) do
    result_position_details = existing_position_details
    result_position_details.delete_if do |el|
      el["name"] == params[:name] &&
      el["start_month"] == params[:start_month] &&
      el["start_year"] == params[:start_year]
    end
    result_position_details = result_position_details.present? ? result_position_details : []
    result_position_details = result_position_details.map(&:to_json)

    @form_answer.document.merge(
      position_details: result_position_details.to_json
    )
  end

  expose(:update_position_result_doc) do
    result_position_details = existing_position_details
    result_position_details[params[:index].to_i] = position_params
    result_position_details = result_position_details.map(&:to_json)

    @form_answer.document.merge(
      position_details: result_position_details.to_json
    )
  end

  def new
  end

  def create
    self.position = Position.new(position_params)

    if position.valid?
      @form_answer.document = add_position_result_doc
      @form_answer.save

      redirect_to form_form_answer_positions_url(@form_answer)
    else
      render :new
    end
  end

  def edit
    self.position = Position.new(existing_position_details[params[:index].to_i])
  end

  def update
    self.position = Position.new(position_params)

    if position.valid?
      @form_answer.document = update_position_result_doc
      @form_answer.save

      redirect_to form_form_answer_positions_url(@form_answer)
    else
      render :edit
    end
  end

  def destroy
    @form_answer.document = remove_position_result_doc
    @form_answer.save

    redirect_to form_form_answer_positions_url(@form_answer)
  end

  private

  def position_params
    params.require(:position).permit(
      :name,
      :details,
      :ongoing,
      :start_month,
      :start_year,
      :end_month,
      :end_year
    )
  end

  def detect_index_of_position_details(attrs)
    result_position_details = existing_position_details

    element = result_position_details.detect do |el|
      el["name"] == attrs["name"] &&
      el["start_month"] == attrs["start_month"] &&
      el["start_year"] == attrs["start_year"]
    end

    result_position_details.index(element)
  end

  helper_method :detect_index_of_position_details
end
