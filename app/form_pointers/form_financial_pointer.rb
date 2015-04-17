class FormFinancialPointer
  include FormAnswersBasePointer

  attr_reader :form_answer,
              :award_form,
              :steps,
              :all_questions,
              :answers,
              :filled_answers,
              :financial_step,
              :target_financial_questions,
              :options

  TARGET_FINANCIAL_DATA_QUESTION_TYPES = [
    QAEFormBuilder::ByYearsLabelQuestion,
    QAEFormBuilder::ByYearsQuestion
  ]
  YEAR_LABELS = %w(day month year)
  IN_PROGRESS = "-"

  TRADE_AUTOEXCLUDED_QUESTION_KEYS = [
  ]

  UK_SALES_EXCLUDED_FORM_TYPES = [
    :trade,
    :promotion
  ]

  def initialize(form_answer, options={})
    @form_answer = form_answer
    @options = options
    @answers = fetch_answers
    @award_form = form_answer.award_form.decorate(answers: answers)

    @steps = award_form.steps
    @financial_step = steps.third

    @all_questions = steps.map(&:questions).flatten
    @filled_answers = fetch_filled_answers

    @target_financial_questions = fetch_financial_questions
  end

  def data
    @data ||= begin
      fetched = target_financial_questions.map do |question|
        FinancialYearPointer.new(
          question: question,
          financial_pointer: self
        ).data
      end

      unless UK_SALES_EXCLUDED_FORM_TYPES.include?(form_answer.object.award_type.to_sym)
        fetched += [UkSalesCalculator.new(fetched).data]
      end

      fetched
    end
  end

  def period_length
    @period_length ||= begin
      if obj = data.first
        case obj
        when Hash
          obj.values.flatten.length
        when Array
          obj.length
        end
      else
        0
      end
    end
  end

  def growth_overseas_earnings(year)
    exports = data_values(:exports)
    exports ||= data_values(:overseas_sales)

    if exports && exports[year] && exports[year - 1] && year != 0
      if exports[year - 1][:value].to_f.zero?
        0
      else
        (exports[year][:value].to_f / exports[year - 1][:value].to_f * 100 - 100).round(2)
      end
    else
      "-"
    end
  end

  def growth_in_total_turnover(year)
    turnover = data_values(:total_turnover)

    if turnover && turnover[year] && turnover[year - 1] && year != 0
      if turnover[year - 1][:value].to_f.zero?
        0
      else
        (turnover[year][:value].to_f / turnover[year - 1][:value].to_f * 100 - 100).round(2)
      end
    else
      "-"
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
      "-"
    end
  end

  def overall_growth
    turnover = data_values(:total_turnover)

    turnover.last && turnover.first ? turnover.last[:value].to_i - turnover.first[:value].to_i : "-"
  end

  def overall_growth_in_percents
    turnover = data_values(:total_turnover)

    if turnover && turnover.any? && !turnover.first[:value].to_f.zero?
      (turnover.last[:value].to_f / turnover.first[:value].to_f * 100 - 100).round(2)
    else
      "-"
    end
  end

  def fetch_financial_questions
    financial_step.questions.select do |question|
      !FormPdf::HIDDEN_QUESTIONS.include?(question.key.to_s) &&
      TARGET_FINANCIAL_DATA_QUESTION_TYPES.include?(question.delegate_obj.class) &&
      award_form[question.key].visible? &&
      !excluded_by_ignored_questions_list?(question)
    end
  end

  def excluded_by_ignored_questions_list?(question)
    (options[:exclude_ignored_questions].present? &&
     excluded_question_keys.present? &&
     excluded_question_keys.include?(question.key))
  end

  def excluded_question_keys
    case form_answer.object.award_type
    when "trade"
      TRADE_AUTOEXCLUDED_QUESTION_KEYS
    end
  end

  private

  def data_values(key)
    values = data.detect { |d| d[key] }
    values && values[key]
  end
end
