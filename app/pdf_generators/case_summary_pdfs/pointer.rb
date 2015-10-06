class CaseSummaryPdfs::Pointer < ReportPdfFormAnswerPointerBase
  include CaseSummaryPdfs::General::DrawElements
  include CaseSummaryPdfs::General::DataPointer

  LOCALE_PREFIX = "admin.form_answers.financial_summary"

  attr_reader :data,
              :financial_pointer,
              :financial_data,
              :year_rows,
              :date_rows,
              :financial_metrics_by_years,
              :growth_overseas_earnings_list,
              :sales_exported_list,
              :average_growth_for_list,
              :growth_in_total_turnover_list,
              :overall_growth,
              :overall_growth_in_percents

  def generate!
    # fetch case_summary or primary (if lead missing)
    @data = form_answer.lead_or_primary_assessor_assignments.first.document
    fetch_financial_data if !form_answer.promotion? && form_answer.submitted?

    main_header
    render_data!
  end

  def fetch_financial_data
    @financial_pointer = FormFinancialPointer.new(form_answer.decorate, {exclude_ignored_questions: true})
    @financial_data = financial_pointer.data

    @year_rows = financial_pointer.years_list.unshift("")

    @date_rows = if @financial_data.first[:financial_year_changed_dates].present?
      financial_pointer.financial_year_changed_dates
    else
      financial_pointer.financial_year_dates
    end.unshift(I18n.t("#{LOCALE_PREFIX}.years_row.financial_year_changed_dates"))

    @financial_metrics_by_years = fetch_financial_metrics_by_years
    set_financial_benchmarks
  end

  def fetch_financial_metrics_by_years
    data_rows = []

    @financial_data.each_with_index do |row, index|
      next if row[:financial_year_changed_dates]

      data_rows << if row[:uk_sales]
        row.values.flatten
           .map do |field|
             formatted_uk_sales_value(field)
           end.unshift(I18n.t("#{LOCALE_PREFIX}.uk_sales_row.#{row.keys.first}"))
      else
        row.values.flatten
           .map do |field|
             ApplicationController.helpers.number_with_delimiter(field[:value])
           end.unshift(I18n.t("#{LOCALE_PREFIX}.row.#{row.keys.first}"))
      end
    end

    data_rows
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
