module PdfAuditCertificates::Awards2016::Development
  class Base < PdfAuditCertificates::Base
    # HERE YOU CAN OVERRIDE STANDART METHODS

    FIRST_TABLE_ROWS = %i[employees total_turnover exports uk_sales net_profit total_net_assets].freeze

    def header_full_award_type
      "Sustainable Development Award"
    end

    def render_accountant_guidance_section
      render_accountant_guidance_intro
      move_down 3.mm
      render_accountant_guidance_parent_figures
      move_down 3.mm
      render_accountant_guidance_estimated_figures
      move_down 3.mm
      render_accountant_guidance_employees
      move_down 3.mm
      render_accountant_guidance_general_notes
      move_down 3.mm
    end

    def render_financial_table
      render_text_line("FIGURES TO BE REVISED OR VERIFIED", 3, style: :bold)

      render_financial_main_table
    end

    def render_financial_main_table
      render_text_line("The UK Business Financials", 2, style: :bold)

      rows = [
        financial_pointer.years_list.unshift(""),
        financial_table_year_and_date_data,
      ]

      rows << revised_row(rows.last.length - 1, 1)

      data = financial_pointer.data

      FIRST_TABLE_ROWS.each_with_index do |field, index|
        row = data.detect { |r| r[field] }

        rows << if field == :uk_sales
                  render_financial_uk_sales_row(row, index + 2)
                else
                  render_financial_row(row, index + 2)
                end

        rows << revised_row(row.values.first.length, index + 2)
      end

      table(rows, table_default_ops(:main_table)) do
        rows.each_with_index do |row, i|
          style(row(i), text_color: "808080") if row.first.include?("Revised")
        end
      end
    end
  end
end
