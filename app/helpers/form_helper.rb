module FormHelper
  def possible_read_only_ops
    ops = {}

    if current_form_is_not_editable?
      ops[:disabled] = "disabled"
      ops[:class] = "read-only"
    end

    ops
  end

  def current_form_is_editable?
    !current_form_is_not_editable?
  end

  def current_form_is_not_editable?
    admin_in_read_only_mode? || current_form_submission_ended?
  end

  def next_step(form, step)
    return unless step

    steps = form.steps
    steps.map! { |s| s.title.parameterize }

    index = steps.index(step)

    steps[index + 1]
  end

  def text_words_count(text)
    text.to_s.split.count
  end

  def application_collaborator_group_mode?
    current_form_is_editable? &&
    @form_answer.has_more_than_one_contributor?
  end
end
