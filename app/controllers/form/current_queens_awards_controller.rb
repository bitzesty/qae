class Form::CurrentQueensAwardsController < Form::BaseController

  # This controller handles saving of CurrentQueensAwards
  # This section is used in case if JS disabled

  expose(:step) do
    @form.steps.detect { |s| s.title == "Company Information" }
  end

  expose(:question) do
    step.questions.detect { |q| q.key == :queen_award_holder_details }
  end

  expose(:categories) do
    question.categories
  end

  expose(:years) do
    question.years
  end

  expose(:existing_current_queens_awards_doc) do
    @form_answer.document["queen_award_holder_details"]
  end

  expose(:existing_current_queens_awards) do
    if existing_current_queens_awards_doc.present?
      JSON.parse(existing_current_queens_awards_doc).map do |el|
        JSON.parse(el)
      end
    else
      {}
    end
  end

  expose(:current_queens_award) do
    CurrentQueensAward.new(categories, years, {})
  end

  expose(:created_current_queens_award_ops) do
    {
      "category" => current_queens_award_params[:category],
      "year" => current_queens_award_params[:year]
    }
  end

  expose(:add_current_queens_award_result_doc) do
    result_current_queens_awards = existing_current_queens_awards
    result_current_queens_awards.push(created_current_queens_award_ops)
    result_current_queens_awards = result_current_queens_awards.map(&:to_json)

    @form_answer.document.merge(
      queen_award_holder_details: result_current_queens_awards.to_json
    )
  end

  expose(:remove_current_queens_award_result_doc) do
    result_current_queens_awards = existing_current_queens_awards
    result_current_queens_awards.delete_if do |el|
      el["category"] == params[:category] &&
      el["year"] == params[:year]
    end

    result_current_queens_awards = if result_current_queens_awards.present?
      result_current_queens_awards
    else
      []
    end

    result_current_queens_awards = result_current_queens_awards.map(&:to_json)

    @form_answer.document.merge(
      queen_award_holder_details: result_current_queens_awards.to_json
    )
  end

  def new
  end

  def create
    self.current_queens_award = CurrentQueensAward.new(
      categories,
      years,
      current_queens_award_params)

    if current_queens_award.valid?
      @form_answer.document = add_current_queens_award_result_doc
      @form_answer.save

      redirect_to edit_form_url(
        id: @form_answer.id,
        anchor: "non_js_queens-awards-list-question"
      )
    else
      render :new
    end
  end

  def confirm_deletion
  end

  def destroy
    @form_answer.document = remove_current_queens_award_result_doc
    @form_answer.save

    redirect_to edit_form_url(
      id: @form_answer.id,
      anchor: "non_js_queens-awards-list-question"
    )
  end

  private

    def current_queens_award_params
      params.require(:current_queens_award).permit(
        :category,
        :year
      )
    end
end
