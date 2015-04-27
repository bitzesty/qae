class Form::AwardsController < Form::BaseController

  # This controller handles saving of Awards
  # This section is used in case if JS disabled

  expose(:step) do
    @form.steps.detect { |s| s.title == "Nominee" }
  end

  expose(:input_name) do
    params[:holder].present? ? "awards" : "nomination_awards"
  end

  expose(:anchor) do
    "non_js_#{input_name}-list-question"
  end

  expose(:question) do
    step.questions.detect { |q| q.key == input_name.to_sym }
  end

  expose(:existing_awards_doc) do
    @form_answer.document[input_name]
  end

  expose(:existing_awards) do
    if existing_awards_doc.present?
      JSON.parse(existing_awards_doc).map do |el|
        JSON.parse(el)
      end
    else
      []
    end
  end

  expose(:award) do
    Award.new(question, params[:holder], {})
  end

  expose(:created_award_ops) do
    attrs = {
      "title" => award_params[:title],
      "details" => award_params[:details]
    }

    attrs["year"] = award_params[:year] if params[:holder].present?
    attrs
  end

  expose(:add_award_result_doc) do
    result_awards = existing_awards
    result_awards.push(created_award_ops)
    result_awards = result_awards.map(&:to_json)

    @form_answer.document.merge(
      input_name.to_sym => result_awards.to_json
    )
  end

  expose(:remove_award_result_doc) do
    result_awards = existing_awards
    result_awards.delete_if do |el|
      if params[:holder].present?
        el["title"] == params[:title] &&
        el["year"] == params[:year]
      else
        el["title"] == params[:title]
      end
    end

    result_awards = if result_awards.present?
      result_awards
    else
      []
    end

    result_awards = result_awards.map(&:to_json)

    @form_answer.document.merge(
      input_name.to_sym => result_awards.to_json
    )
  end

  def new
  end

  def create
    self.award = Award.new(question, params[:holder], award_params)

    if award.valid?
      @form_answer.document = add_award_result_doc
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
    self.award = Award.new(question, params[:holder], award_params)
  end

  def destroy
    @form_answer.document = remove_award_result_doc
    @form_answer.save

    redirect_to edit_form_url(
      id: @form_answer.id,
      anchor: anchor
    )
  end

  private

  def award_params
    params.require(:award).permit(
      :title,
      :year,
      :details
    )
  end
end
