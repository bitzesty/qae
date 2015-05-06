class CaseSummaryPdfs::Pointer < ReportPdfFormAnswerPointerBase
  include CaseSummaryPdfs::General::DrawElements
  include CaseSummaryPdfs::General::DataPointer

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
    # fetch lead_case_summary or primary (if lead missing)
    @data = form_answer.lead_or_primary_assessor_assignments.first.document
    fetch_financial_data if !form_answer.promotion? && form_answer.submitted?

    main_header
    render_data!
  end

  def fetch_financial_data
    @financial_pointer = FormFinancialPointer.new(form_answer.decorate, {exclude_ignored_questions: true})
    @financial_data = financial_pointer.data

    @year_rows = financial_pointer.years_list

    @date_rows = if @financial_data.first[:financial_year_changed_dates].present?
      financial_pointer.financial_year_changed_dates
    else
      financial_pointer.financial_year_dates
    end

    @financial_metrics_by_years = fetch_financial_metrics_by_years
    set_financial_benchmarks
  end

  def fetch_financial_metrics_by_years
    data_rows = []

    @financial_data.each_with_index do |row, index|
      next if row[:financial_year_changed_dates]

      data_rows << if row[:uk_sales]
        row.values.flatten
      else
        row.values.flatten.map { |field| field[:value] }
      end
    end

    data_rows
  end

  def set_financial_benchmarks
    @growth_overseas_earnings_list = financial_pointer.growth_overseas_earnings_list
    @sales_exported_list = financial_pointer.sales_exported_list
    @average_growth_for_list = financial_pointer.average_growth_for_list
    @growth_in_total_turnover_list = financial_pointer.growth_in_total_turnover_list
    @overall_growth = financial_pointer.overall_growth
    @overall_growth_in_percents = financial_pointer.overall_growth_in_percents
  end
end
