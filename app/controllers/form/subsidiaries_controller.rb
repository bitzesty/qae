class Form::SubsidiariesController < Form::BaseController

  # This controller handles saving of Subsidiaries on Trade Form
  # This section is used in case if JS disabled

  expose(:step) do
    @form.steps.detect { |s| s.name == "Company Information" }
  end

  expose(:input_name) do
    "trading_figures_add"
  end

  expose(:anchor) do
    "non_js_#{input_name}-list-question"
  end

  expose(:question) do
    step.questions.detect { |q| q.key == input_name.to_sym }
  end

  expose(:existing_subsidiaries_doc) do
    @form_answer.document[input_name]
  end

  expose(:existing_subsidiaries) do
    if existing_subsidiaries_doc.present?
      JSON.parse(existing_subsidiaries_doc).map do |el|
        JSON.parse(el)
      end
    else
      []
    end
  end

  expose(:subsidiary) do
    Subsidiary.new
  end

  expose(:created_subsidiary_ops) do
    {
      "name" => subsidiary_params[:name],
      "location" => subsidiary_params[:location],
      "employees" => subsidiary_params[:employees]
    }
  end

  expose(:add_subsidiary_result_doc) do
    result_subsidiaries = existing_subsidiaries
    result_subsidiaries.push(created_subsidiary_ops)
    result_subsidiaries = result_subsidiaries.map(&:to_json)

    @form_answer.document.merge(
      input_name.to_sym => result_subsidiaries.to_json
    )
  end

  expose(:remove_subsidiary_result_doc) do
    result_subsidiaries = existing_subsidiaries
    result_subsidiaries.delete_if do |el|
      el["name"] == params[:name] &&
      el["location"] == params[:location]
    end

    result_subsidiaries = if result_subsidiaries.present?
      result_subsidiaries
    else
      []
    end

    result_subsidiaries = result_subsidiaries.map(&:to_json)

    @form_answer.document.merge(
      input_name.to_sym => result_subsidiaries.to_json
    )
  end

  def new
  end

  def create
    self.subsidiary = Subsidiary.new(subsidiary_params)

    if subsidiary.valid?
      @form_answer.document = add_subsidiary_result_doc
      @form_answer.save

      redirect_to edit_form_url(
        id: @form_answer.id,
        anchor: anchor
      )
    else
      render :new
    end
  end

  def confirm_deletion
    self.subsidiary = Subsidiary.new(subsidiary_params)
  end

  def destroy
    @form_answer.document = remove_subsidiary_result_doc
    @form_answer.save

    redirect_to edit_form_url(
      id: @form_answer.id,
      anchor: anchor
    )
  end

  private

  def subsidiary_params
    params.require(:subsidiary).permit(
      :name,
      :location,
      :employees
    )
  end
end
