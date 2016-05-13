class FinancialYearPointer
  include LatestYearGenerator

  attr_reader :financial_pointer,
              :question,
              :key

  def initialize(ops = {})
    ops.each do |k, v|
      instance_variable_set("@#{k}", v)
    end

    @key = question.key
  end

  def data
    {
      key => fetch_data
    }
  end

  def fetch_data
    case question.delegate_obj
    when QAEFormBuilder::ByYearsLabelQuestion
      fetch_year_labels
    when QAEFormBuilder::ByYearsQuestion
      fetch_years
    end
  end

  def fetch_year_labels
    entries.push(latest_year_label)
  end

  def fetch_years
    active_fields.map do |field|
      value = entry(field).to_s.delete(",")
      {
        value: value.present? ? value : FormFinancialPointer::IN_PROGRESS,
        name: "#{key}_#{field}"
      }
    end
  end

  def active_fields
    question.decorate(answers: financial_pointer.filled_answers).
             active_fields
  end

  def entries
    question.active_fields[0..-2].map do |field|
      FormFinancialPointer::YEAR_LABELS.map do |year_label|
        entry(field, year_label)
      end
    end
  end

  def entry(field, year_label = nil)
    entry = financial_pointer.filled_answers.detect do |k, _v|
      k == "#{key}_#{field}#{year_label}"
    end

    entry[1] if entry.present?
  end

  def latest_year_label
    day = financial_pointer.filled_answers["financial_year_date_day"].to_s
    month = financial_pointer.filled_answers["financial_year_date_month"].to_s
    year = calculate_last_year(financial_pointer.form_answer, month.to_i)

    day = "0" + day if day.size == 1
    month = "0" + month if month.size == 1

    [day, month, year ]
  end
end
