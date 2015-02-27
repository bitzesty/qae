class FormFinancialPointer
  include FormAnswersBasePointer

  attr_reader :form_answer,
              :award_form,
              :steps,
              :all_questions,
              :answers,
              :filled_answers,
              :financial_step,
              :target_financial_questions

  TARGET_FINANCIAL_DATA_QUESTION_TYPES = [
    QAEFormBuilder::ByYearsLabelQuestion,
    QAEFormBuilder::ByYearsQuestion
  ]
  YEAR_LABELS = %w(day month year)
  IN_PROGRESS = "-"

  def initialize(form_answer)
    @form_answer = form_answer
    @answers = fetch_answers
    @award_form = form_answer.award_form.decorate(answers: answers)

    @steps = award_form.steps
    @financial_step = steps.third

    @all_questions = steps.map(&:questions).flatten
    @filled_answers = fetch_filled_answers

    @target_financial_questions = fetch_financial_questions
  end

  def data
    target_financial_questions.map do |question|
      FinancialYearPointer.new(
        question: question,
        financial_pointer: self
      ).data
    end
  end

  def fetch_financial_questions
    financial_step.questions.select do |question|
      !FormPdf::HIDDEN_QUESTIONS.include?(question.key.to_s) &&
      TARGET_FINANCIAL_DATA_QUESTION_TYPES.include?(question.delegate_obj.class) &&
      award_form[question.key].visible?
    end
  end
end
