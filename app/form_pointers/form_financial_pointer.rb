class FormFinancialPointer
  include FormAnswersBasePointer
  include LatestYearGenerator

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
    QaeFormBuilder::ByYearsLabelQuestion,
    QaeFormBuilder::ByYearsQuestion,
    QaeFormBuilder::OneOptionByYearsLabelQuestion,
    QaeFormBuilder::OneOptionByYearsQuestion,
  ]
  YEAR_LABELS = %w(day month year)
  IN_PROGRESS = "-"

  TRADE_AUTOEXCLUDED_QUESTION_KEYS = [
  ]

  UK_SALES_EXCLUDED_FORM_TYPES = [
    :trade,
    :promotion,
  ]

  def initialize(form_answer, options = {})
    @form_answer = form_answer
    @options = options
    @answers = fetch_answers
    @award_form = form_answer.award_form.decorate(answers: answers)
    @form_answer_award_year = form_answer.award_year.year

    @steps = award_form.steps
    @financial_step = steps[form_answer.financial_step]

    @all_questions = steps.map(&:questions).flatten
    @filled_answers = fetch_filled_answers
    @target_financial_questions = fetch_financial_questions
  end

  def data
    @data ||= begin
      fetched = target_financial_questions.map do |question|
        FinancialYearPointer.new(
          question: question,
          financial_pointer: self,
        ).data
      end

      unless UK_SALES_EXCLUDED_FORM_TYPES.include?(form_answer.object.award_type.to_sym)
        uk_sales_data = UkSalesCalculator.new(fetched).data

        if index = fetched.index { |data| data[:exports].present? }
          fetched.insert(index + 1, uk_sales_data) if uk_sales_data.present?
        elsif uk_sales_data.present?
          fetched += [uk_sales_data]
        end
      end

      fetched
    end
  end

  def period_length(exclude_innovation_years = true)
    if exclude_innovation_years
      reduced_period_length
    else
      full_period_length
    end
  end

  def data_minmax(h)
    h.each_with_object(Hash[:min, nil, :max, nil]) do |field, memo|
      length = field.values[0].length
      memo[:min] = length if memo[:min].nil? || length < memo[:min]
      memo[:max] = length if memo[:max].nil? || length > memo[:max]
    end.transform_values { |v| v.nil? ? 0 : v }
  rescue
    Hash[:min, 0, :max, 0]
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

  def overall_growth_values
    form_answer.trade? ? data_values(:overseas_sales) : data_values(:total_turnover)
  end

  def overall_growth
    res = overall_growth_values
    (res && res.last && res.first) ? res.last[:value].to_i - res.first[:value].to_i : "-"
  end

  def overall_growth_in_percents
    res = overall_growth_values

    if res && res.any? && !res.first[:value].to_f.zero?
      (res.last[:value].to_f / res.first[:value].to_f * 100 - 100).round(2)
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
    options[:exclude_ignored_questions].present? &&
      excluded_question_keys.present? &&
      excluded_question_keys.include?(question.key)
  end

  def excluded_question_keys
    case form_answer.object.award_type
    when "trade"
      TRADE_AUTOEXCLUDED_QUESTION_KEYS
    end
  end

  def years_list(exclude_innovation_years = false)
    res = []

    period_length(exclude_innovation_years).times do |i|
      res << "Year #{i + 1}"
    end

    res
  end

  def financial_year_dates
    res = []

    period_length.times do |i|
      day = form_answer.document["financial_year_date_day"].to_s
      month = form_answer.document["financial_year_date_month"].to_s
      year = calculate_last_year(form_answer, day, month) - period_length + i + 1

      res << [
        day.rjust(2, "0"),
        month.rjust(2, "0"),
        year,
      ].join("/")
    end

    res
  end

  def financial_year_changed_dates
    dates_by_years = data_values(:financial_year_changed_dates)

    if dates_by_years.present?
      res = []
      last_year = dates_by_years.last.split("/")[-1][-1].to_i

      dates_by_years.each do |date|
        res << date.join("/")
      end

      res
    else
      []
    end
  end

  def growth_overseas_earnings_list
    res = []

    period_length.times do |i|
      res << growth_overseas_earnings(i)
    end

    res
  end

  def sales_exported_list
    res = []

    period_length.times do |i|
      res << sales_exported(i)
    end

    res
  end

  def average_growth_for_list
    res = []

    period_length.times do |i|
      res << average_growth_for(form_answer, i + 1)
    end

    res
  end

  def growth_in_total_turnover_list
    res = []

    period_length.times do |i|
      res << growth_in_total_turnover(i)
    end

    res
  end

  def average_growth_for(form_answer, year)
    growth = form_answer.average_growth_for(year)
    growth || "-"
  end

  def partitioned_hash
    target_financial_questions.group_by(&:section)
                              .transform_values { |values| values.map(&:key) }
  end

  private

  def reduced_period_length
    @_reduced_period_length ||= begin
      excluded_keys = partitioned_hash.fetch(:innovation_financials, [])
      reduced = data.reject { |h| h.keys[0].in?(excluded_keys) }

      data_minmax(reduced).dig(:max)
    end
  end

  def full_period_length
    @_full_period_length ||= data_minmax(data).dig(:max)
  end

  def data_values(key)
    values = data.detect { |d| d[key] }
    values && values[key]
  end
end
