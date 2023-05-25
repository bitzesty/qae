class QAEFormBuilder
  class TradeMostRecentFinancialYearOptionsQuestionValidator < OptionsQuestionValidator
    def errors
      result = {}

      date, range = question.get_changeable_date_range

      if date.present? && range.present? && !date.in?(range) && question.year_has_changed?
        result[question.key] = "You can only change the year if your dates in question D2 range between #{from.decorate.formatted_trigger_date} to #{to.decorate.formatted_trigger_date}."
      end

      result
    end
  end

  class TradeMostRecentFinancialYearOptionsQuestionBuilder < OptionsQuestionBuilder
  end

  class TradeMostRecentFinancialYearOptionsQuestion < OptionsQuestion
  end

  class TradeMostRecentFinancialYearOptionsQuestionDecorator < QuestionDecorator
    def financial_year_date_parts
      @_financial_year_date_parts ||=
        Hash[].tap do |h|
          h[:day] = answers[:financial_year_date_day]
          h[:month] = answers[:financial_year_date_month]

          h.transform_values! { |v| v.blank? ? nil : v.to_i }
        end
    end

    def year_has_changed?
      input_value.to_i == (AwardYear.current.year - 2)
    end

    def year_changeable?
      date, range = get_changeable_date_range
      date.present? && range.present? && date.in?(range) && year_has_changed?
    end

    def get_changeable_date_range
      from = Settings.current_award_year_switch_date
      to = Settings.current_submission_deadline

      from_ts = from&.trigger_at
      to_ts = to&.trigger_at

      date, range = if [from_ts, to_ts].all?(&:present?)
                      r = (Date.new(1900, from_ts.month, from_ts.day)..Date.new(1900, to_ts.month, to_ts.day))
                      d = if financial_year_date_parts.values.none?(&:nil?)
                        Date.new(1900, financial_year_date_parts[:month], financial_year_date_parts[:day])
                      end

                      [d, r]
                    end

      [date, range]
    end
  end
end
