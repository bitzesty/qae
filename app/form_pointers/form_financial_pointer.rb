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
    @data ||= target_financial_questions.map do |question|
      FinancialYearPointer.new(
        question: question,
        financial_pointer: self
      ).data
    end
  end

  def period_length
    @period_length ||= data.first ? data.first.values.flatten.size : 0
  end

  def growth_overseas_earnings(year)
    exports = data_values(:exports)
    exports ||= data_values(:overseas_sales)

    if exports && exports[year] && exports[year - 1] && year != 0
      if exports[year - 1][:value].to_f.zero?
        0
      else
        (exports[year][:value].to_f  / exports[year - 1][:value].to_f * 100 - 100).round(2)
      end
    else
      '-'
    end
  end

  def sales_exported(year)
    export = data_values(:exports)
    export ||= data_values(:overseas_sales)
    total_turnover = data_values(:total_turnover)

    if export && total_turnover && export[year] && total_turnover[year]
      if total_turnover[year][:value].to_f.zero?
        0
      else
        (export[year][:value].to_f / total_turnover[year][:value].to_f * 100).round(2)
      end
    else
      '-'
    end
  end

  def overall_growth
    turnover = data_values(:total_turnover)

    turnover.last && turnover.first ? turnover.last[:value].to_i - turnover.first[:value].to_i : '-'
  end

  def overall_growth_in_percents
    turnover = data_values(:total_turnover)

    if turnover && turnover.any? && !turnover.first[:value].to_f.zero?
      (turnover.last[:value].to_f / turnover.first[:value].to_f * 100 -100).round(2)
    else
      '-'
    end
  end

  def fetch_financial_questions
    financial_step.questions.select do |question|
      !FormPdf::HIDDEN_QUESTIONS.include?(question.key.to_s) &&
      TARGET_FINANCIAL_DATA_QUESTION_TYPES.include?(question.delegate_obj.class) &&
      award_form[question.key].visible?
    end
  end

  private

  def data_values(key)
    values = data.detect { |d| d[key] }
    values && values[key]
  end
end
