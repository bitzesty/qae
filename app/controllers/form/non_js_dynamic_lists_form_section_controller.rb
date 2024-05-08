class Form::NonJsDynamicListsFormSectionController < Form::BaseController
  # Base controller for NON JS evrsion of Form dynamic lists sections

  expose(:step) do
    @form.steps.detect { |s| s.title == step_name }
  end

  expose(:question) do
    step.questions.detect { |q| q.key == input_name.to_sym }
  end

  expose(:existing_list_doc) do
    @form_answer.document[input_name]
  end

  expose(:existing_parsed_list_doc) do
    if existing_list_doc.present?
      existing_list_doc
    else
      []
    end
  end

  expose(:ops_hash) {
    ActiveSupport::HashWithIndifferentAccess.new(item_params)
  }

  expose(:anchor) do
    "non_js_#{input_name}-list-question"
  end

  expose(:add_result_doc) do
    res = existing_parsed_list_doc
    res.push(created_item_ops)

    @form_answer.document.merge(
      input_name => res,
    )
  end

  expose(:remove_result_doc) do
    res = existing_parsed_list_doc
    res.delete_if do |el|
      item_detect_condition(el)
    end

    res = res.present? ? res : []

    @form_answer.document.merge(
      input_name => res,
    )
  end

  expose(:update_result_doc) do
    res = existing_parsed_list_doc
    res[params[:index].to_i] = item_params

    @form_answer.document.merge(
      input_name => res,
    )
  end

  def detect_index_of_element(attrs)
    res = existing_parsed_list_doc

    element = res.detect do |el|
      item_detect_condition(el, attrs)
    end

    res.index(element)
  end

  helper_method :detect_index_of_element
end
