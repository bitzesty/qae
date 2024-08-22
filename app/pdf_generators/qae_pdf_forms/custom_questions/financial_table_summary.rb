module QaePdfForms::CustomQuestions::FinancialTableSummary
  include ActionView::Helpers::NumberHelper

  ###########################
  # TRADE FINANCIAL SUMMARY #
  ###########################

  def render_trade_financial_summary
    # main table

    form_pdf.render_text "The data below is pulled from previous questions and automatically calculated. It is there to help you ensure you entered the correct figures and see your growth."

    form_pdf.render_text "Financial data you have entered", style: :bold

    form_pdf.render_text "The table below displays the financial data you have entered in the table format. Please check that the numbers you entered are correct. You can edit the financial data in relevant questions in the D5 section of this form."

    form_pdf.move_cursor_to form_pdf.cursor - 5.mm

    rows = []

    rows << [""] + fs_enumerize_years(fs_financial_table_headers_filled_in)
    rows << ["D5.1 Overseas sales (£)"] + format_number(fs_get_all_financial_values(:overseas_sales))
    rows << ["D5.2 Turnover (£)"] + format_number(fs_get_all_financial_values(:total_turnover))
    rows << ["D5.3 Net profit after tax but before dividends (£)"] + format_number(fs_get_all_financial_values(:net_profit))

    form_pdf.table(rows, fs_table_default_ops)
    form_pdf.move_cursor_to form_pdf.cursor - 3.mm

    # growth table

    form_pdf.render_text "Overseas sales annual percentages", style: :bold

    form_pdf.render_text "The table below displays the financial data calculated from the figures you have entered in questions D5.1 and D5.2."

    form_pdf.move_cursor_to form_pdf.cursor - 5.mm

    growth_rows = []

    growth_rows << [""] + fs_enumerize_years(fs_financial_table_headers_filled_in)
    growth_rows << ["Year on year overseas sales growth (%)"] + format_number(fs_calculate_growth(fs_get_all_financial_values(:overseas_sales)))
    growth_rows << ["Overseas sales as percentage of turnover (%)"] + format_number(fs_calculate_proportion(fs_get_all_financial_values(:overseas_sales), fs_get_all_financial_values(:total_turnover)))

    form_pdf.table(growth_rows, fs_table_default_ops)
    form_pdf.move_cursor_to form_pdf.cursor - 3.mm

    # overall_growth table

    form_pdf.render_text "Overall overseas sales growth", style: :bold

    form_pdf.render_text "The table below displays the financial data calculated from the figures you have entered in question D5.1."

    form_pdf.move_cursor_to form_pdf.cursor - 5.mm

    overall_growth_rows = []

    overall_growth_rows << ["Overall overseas sales growth in £ \n\r #{fs_overall_growth_year_note(:total)}"] + format_number(fs_calculate_overall_growth(fs_get_all_financial_values(:overseas_sales)))
    overall_growth_rows << ["Overall overseas sales growth % \n\r #{fs_overall_growth_year_note(:percent)}"] + format_number(fs_calculate_overall_growth_percentage(fs_get_all_financial_values(:overseas_sales)))

    form_pdf.table(overall_growth_rows, fs_table_default_ops.merge(column_widths: fs_overall_table_column_widths))
  end

  def fs_trade_filled_in?
    fs_financial_table_headers_filled_in.present? &&
      fs_financial_table_headers_filled_in.all?(&:present?) &&
      fs_all_trade_financial_data_filled_in?
  end

  def fs_all_trade_financial_data_filled_in?
    %w[overseas_sales total_turnover net_profit].all? do |key|
      fs_get_all_financial_values(key).all?(&:present?)
    end
  end

  #############################
  # / TRADE FINANCIAL SUMMARY #
  #############################

  #################################
  # DEVELOPMENT FINANCIAL SUMMARY #
  #################################

  def render_development_financial_summary
    # main table

    form_pdf.render_text "The data below is pulled from previous questions and automatically calculated. It is there to help you ensure you entered the correct figures and see your growth."

    form_pdf.render_text "Financial data you have entered", style: :bold

    form_pdf.render_text "The table below displays the financial data you have entered in the table format. Please check that the numbers you entered are correct. You can edit the financial data in relevant questions in the D4 section of this form."

    form_pdf.move_cursor_to form_pdf.cursor - 5.mm

    rows = []

    rows << [""] + fs_enumerize_years(fs_financial_table_headers_filled_in)
    rows << ["D4.1 Turnover (£)"] + format_number(fs_get_all_financial_values(:total_turnover))
    rows << ["D4.2 Of which exports (£)"] + format_number(fs_get_all_financial_values(:exports))
    rows << ["D4.3 Of which UK sales (£)"] + format_number(fs_get_all_financial_values(:uk_sales, true))
    rows << ["D4.4 Net profit after tax but before dividends (£)"] + format_number(fs_get_all_financial_values(:net_profit))
    rows << ["D4.5 Net assets (£)"] + format_number(fs_get_all_financial_values(:total_net_assets))

    form_pdf.table(rows, fs_table_default_ops)
    form_pdf.move_cursor_to form_pdf.cursor - 3.mm

    # growth table

    form_pdf.render_text "Turnover annual percentages", style: :bold

    form_pdf.render_text "The table below displays the financial data calculated from the figures you have entered in questions D4.1"

    form_pdf.move_cursor_to form_pdf.cursor - 5.mm

    growth_rows = []

    growth_rows << [""] + fs_enumerize_years(fs_financial_table_headers_filled_in)
    growth_rows << ["Year on year turnover growth (%)"] + format_number(fs_calculate_growth(fs_get_all_financial_values(:total_turnover)))

    form_pdf.table(growth_rows, fs_table_default_ops)
    form_pdf.move_cursor_to form_pdf.cursor - 3.mm

    # overall_growth table

    form_pdf.render_text "Overall turnover growth", style: :bold

    form_pdf.render_text "The table below displays the financial data calculated from the figures you have entered in question D4.1."

    form_pdf.move_cursor_to form_pdf.cursor - 5.mm

    overall_growth_rows = []

    overall_growth_rows << ["Overall turnover growth in £ \n\r #{fs_overall_growth_year_note(:total)}"] + format_number(fs_calculate_overall_growth(fs_get_all_financial_values(:total_turnover)))
    overall_growth_rows << ["Overall turnover growth % \n\r #{fs_overall_growth_year_note(:percent)}"] + format_number(fs_calculate_overall_growth_percentage(fs_get_all_financial_values(:total_turnover)))

    form_pdf.table(overall_growth_rows, fs_table_default_ops.merge(column_widths: fs_overall_table_column_widths))
  end

  def fs_development_filled_in?
    fs_financial_table_headers_filled_in.present? &&
      fs_financial_table_headers_filled_in.all?(&:present?) &&
      fs_all_development_financial_data_filled_in?
  end

  def fs_all_development_financial_data_filled_in?
    %w[total_turnover exports net_profit total_net_assets].all? do |key|
      fs_get_all_financial_values(key).all?(&:present?)
    end
  end

  ###################################
  # / DEVELOPMENT FINANCIAL SUMMARY #
  ###################################

  ##############################
  # MOBILITY FINANCIAL SUMMARY #
  ##############################

  def render_mobility_financial_summary
    # main table

    form_pdf.render_text "The data below is pulled from previous questions and automatically calculated. It is there to help you ensure you entered the correct figures and see your growth."

    form_pdf.render_text "Financial data you have entered", style: :bold

    form_pdf.render_text "The table below displays the financial data you have entered in the table format. Please check that the numbers you entered are correct. You can edit the financial data in relevant questions in the D4 section of this form."

    form_pdf.move_cursor_to form_pdf.cursor - 5.mm

    rows = []

    rows << [""] + fs_enumerize_years(fs_financial_table_headers_filled_in)
    rows << ["D4.1 Turnover (£)"] + format_number(fs_get_all_financial_values(:total_turnover))
    rows << ["D4.2 Net profit after tax but before dividends (£)"] + format_number(fs_get_all_financial_values(:net_profit))
    rows << ["D4.3 Net assets (£)"] + format_number(fs_get_all_financial_values(:total_net_assets))

    form_pdf.table(rows, fs_table_default_ops)
    form_pdf.move_cursor_to form_pdf.cursor - 3.mm

    # growth table

    form_pdf.render_text "Turnover annual percentages", style: :bold

    form_pdf.render_text "The table below displays the financial data calculated from the figures you have entered in questions D4.1"

    form_pdf.move_cursor_to form_pdf.cursor - 5.mm

    growth_rows = []

    growth_rows << [""] + fs_enumerize_years(fs_financial_table_headers_filled_in)
    growth_rows << ["Year on year turnover growth (%)"] + format_number(fs_calculate_growth(fs_get_all_financial_values(:total_turnover)))

    form_pdf.table(growth_rows, fs_table_default_ops)
    form_pdf.move_cursor_to form_pdf.cursor - 3.mm

    # overall_growth table

    form_pdf.render_text "Overall turnover growth", style: :bold

    form_pdf.render_text "The table below displays the financial data calculated from the figures you have entered in question D4.1."

    form_pdf.move_cursor_to form_pdf.cursor - 5.mm

    overall_growth_rows = []

    overall_growth_rows << ["Overall turnover growth in £ \n\r #{fs_overall_growth_year_note(:total)}"] + format_number(fs_calculate_overall_growth(fs_get_all_financial_values(:total_turnover)))
    overall_growth_rows << ["Overall turnover growth % \n\r #{fs_overall_growth_year_note(:percent)}"] + format_number(fs_calculate_overall_growth_percentage(fs_get_all_financial_values(:total_turnover)))

    form_pdf.table(overall_growth_rows, fs_table_default_ops.merge(column_widths: fs_overall_table_column_widths))
  end

  def fs_mobility_filled_in?
    fs_financial_table_headers_filled_in.present? &&
      fs_financial_table_headers_filled_in.all?(&:present?) &&
      fs_all_mobility_financial_data_filled_in?
  end

  def fs_all_mobility_financial_data_filled_in?
    %w[total_turnover net_profit total_net_assets].all? do |key|
      fs_get_all_financial_values(key).all?(&:present?)
    end
  end

  ################################
  # / MOBILITY FINANCIAL SUMMARY #
  ################################

  ###################################
  # INNOVATION FINANCIAL SUMMARY P1 #
  ###################################

  def render_innovation_financial_summary_part_1
    # main table
    form_pdf.render_text "The data below is pulled from previous questions and automatically calculated. It is there to help you ensure you entered the correct figures and see your growth."

    form_pdf.render_text "Financial data you have entered", style: :bold

    form_pdf.render_text "The table below displays the financial data you have entered in the table format. Please check that the numbers you entered are correct. You can edit the financial data in relevant questions in the D4 section of this form."

    form_pdf.move_cursor_to form_pdf.cursor - 5.mm

    rows = []

    rows << [""] + fs_enumerize_years(fs_financial_table_headers_filled_in)
    rows << ["D4.1 Turnover (£)"] + format_number(fs_get_all_financial_values(:total_turnover))
    rows << ["D4.2 Of which exports (£)"] + format_number(fs_get_all_financial_values(:exports))
    rows << ["D4.3 Of which UK sales (£)"] + format_number(fs_get_all_financial_values(:uk_sales, true))
    rows << ["D4.4 Net profit after tax but before dividends (£)"] + format_number(fs_get_all_financial_values(:net_profit))
    rows << ["D4.5 Net assets (£)"] + format_number(fs_get_all_financial_values(:total_net_assets))

    form_pdf.table(rows, fs_table_default_ops)
    form_pdf.move_cursor_to form_pdf.cursor - 3.mm

    # growth table

    form_pdf.render_text "Turnover annual percentages", style: :bold

    form_pdf.render_text "The table below displays the financial data calculated from the figures you have entered in questions D4.1"

    form_pdf.move_cursor_to form_pdf.cursor - 5.mm

    growth_rows = []

    growth_rows << [""] + fs_enumerize_years(fs_financial_table_headers_filled_in)
    growth_rows << ["Year on year turnover growth (%)"] + format_number(fs_calculate_growth(fs_get_all_financial_values(:total_turnover)))

    form_pdf.table(growth_rows, fs_table_default_ops)
    form_pdf.move_cursor_to form_pdf.cursor - 3.mm

    # overall_growth table

    form_pdf.render_text "Overall turnover growth", style: :bold

    form_pdf.render_text "The table below displays the financial data calculated from the figures you have entered in question D4.1."

    form_pdf.move_cursor_to form_pdf.cursor - 5.mm

    overall_growth_rows = []

    overall_growth_rows << ["Overall turnover growth in £ \n\r #{fs_overall_growth_year_note(:total)}"] + format_number(fs_calculate_overall_growth(fs_get_all_financial_values(:total_turnover)))
    overall_growth_rows << ["Overall turnover growth % \n\r #{fs_overall_growth_year_note(:percent)}"] + format_number(fs_calculate_overall_growth_percentage(fs_get_all_financial_values(:total_turnover)))

    form_pdf.table(overall_growth_rows, fs_table_default_ops.merge(column_widths: fs_overall_table_column_widths))
  end

  def fs_innovation_part_1_filled_in?
    fs_financial_table_headers_filled_in.present? &&
      fs_financial_table_headers_filled_in.all?(&:present?) &&
      fs_all_innovation_part_1_data_filled_in?
  end

  def fs_all_innovation_part_1_data_filled_in?
    %w[total_turnover exports net_profit total_net_assets].all? do |key|
      fs_get_all_financial_values(key).all?(&:present?)
    end
  end

  #####################################
  # / INNOVATION FINANCIAL SUMMARY P1 #
  #####################################

  ###################################
  # INNOVATION FINANCIAL SUMMARY P2 #
  ###################################

  def render_innovation_financial_summary_part_2
    # main table
    form_pdf.render_text "The data below is pulled from previous questions and automatically calculated. It is there to help you ensure you entered the correct figures and see your growth."

    form_pdf.render_text "Financial data you have entered", style: :bold

    form_pdf.render_text "The table below displays the financial data you have entered in the table format. Please check that the numbers you entered are correct. You can edit the financial data in relevant questions in the D4 section of this form."

    form_pdf.move_cursor_to form_pdf.cursor - 5.mm

    rows = []

    rows << [""] + fs_enumerize_years(fs_financial_table_headers_filled_in)
    rows << ["D6.1 Number of units/contracts sold"] + format_number(fs_get_all_financial_values(:units_sold))
    rows << ["D6.2 Sales (in £) of innovative product/service"] + format_number(fs_get_all_financial_values(:sales))
    rows << ["D6.3 Of which exports (£)"] + format_number(fs_get_all_financial_values(:sales_exports))
    rows << ["D6.4 Of which royalties or licences (£)"] + format_number(fs_get_all_financial_values(:sales_royalties))
    rows << ["D6.6 Average unit selling price/contract value (£)"] + format_number(fs_get_all_financial_values(:avg_unit_price))
    rows << ["D6.8 Direct cost of single unit/contract (£)"] + format_number(fs_get_all_financial_values(:avg_unit_cost_self))

    form_pdf.table(rows, fs_table_default_ops)
  end

  def fs_innovation_part_2_filled_in?
    fs_financial_table_headers_filled_in.present? &&
      fs_financial_table_headers_filled_in.all?(&:present?) &&
      fs_all_innovation_part_2_data_filled_in?
  end

  def fs_all_innovation_part_2_data_filled_in?
    %w[units_sold sales sales_exports sales_royalties avg_unit_price avg_unit_cost_self].all? do |key|
      fs_get_all_financial_values(key).all?(&:present?)
    end
  end

  #####################################
  # / INNOVATION FINANCIAL SUMMARY P2 #
  #####################################

  def fs_get_all_financial_values(q_key, calculated = false)
    @fin_values_cache ||= {}
    q_key = q_key.to_s

    return @fin_values_cache[q_key] if @fin_values_cache[q_key]

    if calculated
      if q_key == "uk_sales"
        @fin_values_cache[q_key] = (1..fs_number_of_years).map do |i|
          (form_pdf.filled_answers["total_turnover_#{i}of#{fs_number_of_years}"].to_f - form_pdf.filled_answers["exports_#{i}of#{fs_number_of_years}"].to_f).round
        end
      else
        raise "Not Implemented"
      end
    else
      @fin_values_cache[q_key] = (1..fs_number_of_years).map do |i|
        form_pdf.filled_answers["#{q_key}_#{i}of#{fs_number_of_years}"]
      end

      @fin_values_cache[q_key]
    end
  end

  def fs_number_of_years
    fs_financial_table_headers_filled_in.count
  end

  def fs_financial_table_headers_filled_in
    @financial_table_headers_filled_in ||=
      if financial_year_changed_dates?
        financial_table_changed_dates_headers
      elsif financial_date_day.to_i > 0 && financial_date_month.to_i > 0
        financial_table_pointer_headers
      else
        []
      end
  end

  def fs_table_default_ops
    {
      column_widths: fs_table_column_widths,
      width: 460,
      cell_style: {
        size: 10,
        padding: [3, 3, 3, 3],
      },
    }
  end

  def fs_table_column_widths
    res =
      case fs_number_of_years
      when 2
        [220, 120, 120]
      when 3
        [220, 80, 80, 80]
      when 5
        [160, 60, 60, 60, 60, 60]
      when 6
        [100, 60, 60, 60, 60, 60, 60]
      else
        []
      end

    Hash[res.map.with_index { |x, i| [i, x] }]
  end

  def fs_overall_table_column_widths
    { 0 => 230, 1 => 230 }
  end

  def fs_enumerize_years(years)
    years.map.with_index { |y, i| "#{y}\n\r(Year #{i + 1})" }
  end

  def fs_calculate_growth(values)
    values = values.map(&:to_f)
    growth_percentages = ["-"]

    (1...values.length).each do |i|
      if values[i - 1] != 0
        growth = ((values[i] - values[i - 1]) / values[i - 1]) * 100
        growth_percentages << growth.round.to_s
      else
        growth_percentages << "-" # Handle division by zero
      end
    end

    growth_percentages
  end

  def fs_calculate_proportion(values, values_base)
    values = values.map(&:to_f)
    values_base = values_base.map(&:to_f)
    percentages = []

    values.each_with_index do |value, index|
      base = values_base[index]

      if base != 0
        percentage = (value / base) * 100
        percentages << percentage.round.to_s
      else
        percentages << "-" # Handle division by zero
      end
    end

    percentages
  end

  def fs_overall_growth_year_note(kind)
    case kind
    when :total
      "(year #{fs_number_of_years} minus 1)"
    when :percent
      "(year #{fs_number_of_years} over year 1)"
    end
  end

  def fs_calculate_overall_growth(values)
    [(values.last.to_f - values.first.to_f).round]
  end

  def fs_calculate_overall_growth_percentage(values)
    if values.first.to_f != 0.0
      [(values.last.to_f / values.first.to_f * 100).round.to_s]
    else
      ["-"] # Handle division by zero
    end
  end

  def format_number(values)
    values.map { |v| number_with_delimiter(v) }
  end
end
