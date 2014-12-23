class QaePdfForms::General::StepPointer
  attr_reader :form,
              :step,
              :cached_questions,
              :filtered_questions

  def initialize(ops={})
    ops.each do |k, v|
      instance_variable_set("@#{k}", v)
    end

    @cached_questions = step.questions.reject do |question|
      FormPdf::HIDDEN_QUESTIONS.include?(question.key.to_s)
    end

    @filtered_questions = cached_questions.select do |question|
      conditions_are_allow?(question)
    end
  end

  def render!
    form.start_new_page if step.index.to_i != 0
    render_header

    Rails.logger.info "filtered_questions: #{filtered_questions.count}"

    filtered_questions.each do |question|
      QaePdfForms::General::QuestionPointer.new({
        form: form,
        step: self,
        question: question.decorate
      }).render!
    end
  end

  def render_header
    form.text step.complex_title, style: :bold, 
                                  size: 18, 
                                  align: :left
    form.default_bottom_margin
  end

  def conditions_are_allow?(question)
    conditions = question.conditions
    drop_condition_keys = cached_questions.select do |q| 
      q.drop_condition.present? && 
      q.drop_condition == question.key
    end.map(&:key)

    allowed_by_or_have_no_conditions?(question, conditions, drop_condition_keys)
  end

  def allowed_by_or_have_no_conditions?(question, conditions, drop_condition_keys)
    (
      conditions.blank? ||
      conditions.all? do |condition|
        conditional_success?(question, condition)
      end
    ) &&
    (
      drop_condition_keys.blank? ||
      drop_condition_keys.any? do |key|
        form.at_least_of_one_answer_by_key?(key)
      end
    )
  end

  def conditional_success?(question, condition)
    question_key = condition.question_key
    question_value = condition.question_value
    parent_question_answer = form.fetch_answer_by_key(question_key)

    if question_value == :true
      parent_question_answer.present?
    else
      parent_question_answer == question_value.to_s
    end
  end
end