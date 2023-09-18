class CaseSummaryPdfs::Pointer < ReportPdfFormAnswerPointerBase
  include CaseSummaryPdfs::General::DrawElements
  include CaseSummaryPdfs::General::DataPointer

  LOCALE_PREFIX = "admin.form_answers.financial_summary"
  DATE_LABEL = I18n.t("#{LOCALE_PREFIX}.years_row.label")
  EMPTY_STRING = "".freeze

  attr_reader :data,
              :financial_pointer,
              :financial_data,
              :year_rows,
              :financial_metrics_by_years,
              :growth_overseas_earnings_list,
              :sales_exported_list,
              :average_growth_for_list,
              :growth_in_total_turnover_list,
              :overall_growth,
              :overall_growth_in_percents

  def initialize(pdf_doc, form_answer)
    @pdf_doc = pdf_doc
    @award_year = pdf_doc.award_year
    @form_answer = form_answer
    @answers = fetch_answers
    @award_form = form_answer.award_form.decorate(answers: answers)
    @all_questions = award_form.steps.map(&:questions).flatten
    @filled_answers = fetch_filled_answers

    generate!
  end

  def generate!
    # fetch case_summary or primary (if lead missing)
    @data = form_answer.lead_or_primary_assessor_assignments.first.document
    fetch_financial_data if !form_answer.promotion? && form_answer.submitted?

    main_header
    render_data!
  end

  def fetch_financial_data
    @financial_pointer = FinancialSummaryPointer.new(form_answer.decorate, {
      exclude_ignored_questions: true,
      award_year: @award_year
    })

    @financial_data = financial_pointer.summary_data
    @year_rows = financial_pointer.years_list.unshift("")
    @financial_metrics_by_years = fetch_financial_metrics_by_years

    set_financial_benchmarks
  end

  def fetch_financial_metrics_by_years
    @financial_data.each_with_object([]) do |row, memo|
      key, values = row.each_pair.first

      memo << if key == :dates
        values.map do |value|
          value.nil? ? EMPTY_STRING : value
        end.unshift(DATE_LABEL)
      elsif key == :uk_sales
        values.map do |value|
          value.nil? ? EMPTY_STRING : formatted_uk_sales_value(value)
        end.unshift(I18n.t("#{LOCALE_PREFIX}.uk_sales_row.#{key}"))
      else
        values.map do |h|
          h[:value].nil? ? EMPTY_STRING : ApplicationController.helpers.number_with_delimiter(h[:value])
        end.unshift(I18n.t("#{LOCALE_PREFIX}.row.#{key}"))
      end
    end
  end

  def formatted_uk_sales_value(item)
    ApplicationController.helpers.formatted_uk_sales_value(item)
  end

  def formatter_metrics(list)
    list.map do |item|
      formatted_uk_sales_value(item)
    end
  end

  def set_financial_benchmarks
    @growth_overseas_earnings_list = formatter_metrics financial_pointer.growth_overseas_earnings_list
    @sales_exported_list = formatter_metrics financial_pointer.sales_exported_list
    @average_growth_for_list = formatter_metrics financial_pointer.average_growth_for_list
    @growth_in_total_turnover_list = formatter_metrics financial_pointer.growth_in_total_turnover_list
    @overall_growth = formatted_uk_sales_value financial_pointer.overall_growth
    @overall_growth_in_percents = formatted_uk_sales_value financial_pointer.overall_growth_in_percents
  end
end
