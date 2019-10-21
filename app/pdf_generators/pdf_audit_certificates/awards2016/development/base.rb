module PdfAuditCertificates::Awards2016::Development
  class Base < PdfAuditCertificates::Base
    # HERE YOU CAN OVERRIDE STANDART METHODS

    FIRST_TABLE_ROWS = %i[employees total_turnover exports uk_sales net_profit total_net_assets].freeze
    SECOND_TABLE_ROWS = %i[units_sold sales sales_exports sales_royalties avg_unit_cost_self].freeze

    def header_full_award_type
      "Sustainable Development Award"
    end

    def render_guidance_section
      render_guidance_intro
      move_down 3.mm
      render_guidance_general_notes
      move_down 3.mm
      render_guidance_estimated_figures
      move_down 3.mm
      render_guidance_employees
      move_down 3.mm
    end

    def render_financial_table
      render_text_line("FIGURES TO BE REVISED OR VERIFIED", 3, style: :bold)

      render_financial_main_table

      start_new_page
      render_sd_financial_table
    end

    def render_sd_financial_table
      render_text_line("Sustainable Development Financials", 2, style: :bold)
      intro = "If relevant to their sustainable development, the applicant provided unit price, cost details and sales figures to help us understand the financial value of their sustainable development."

      render_text_line(intro, 2)

      data = financial_pointer.data

      rows = [financial_pointer.years_list.unshift("")]

      SECOND_TABLE_ROWS.each_with_index do |field, index|
        row = data.detect { |r| r[field] }

        rows << render_financial_row(row, index + FIRST_TABLE_ROWS.length + 2)

        rows << revised_row(row.values.first.length, index + FIRST_TABLE_ROWS.length + 2)
      end

      table(rows, table_default_ops(:main_table)) do
        rows.each_with_index do |row, i|
          if row.first.include?("Revised")
            style(row(i), text_color: "808080")
          end
        end
      end
    end

    def render_financial_main_table
      render_text_line("Company Financials", 2, style: :bold)

      rows = [
        financial_pointer.years_list.unshift(""),
        financial_table_year_and_date_data
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
          if row.first.include?("Revised")
            style(row(i), text_color: "808080")
          end
        end
      end
    end
  end
end
