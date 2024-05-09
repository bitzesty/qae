# coding: utf-8
module PdfAuditCertificates::Awards2016::Innovation
  class Base < PdfAuditCertificates::Base
    # HERE YOU CAN OVERRIDE STANDART METHODS

    def raw_data
      @_raw_data ||= financial_pointer.data
    end

    def formatted_data
      @_formatted_data ||= financial_pointer.summary_data
    end

    def partitioned_rows
      indexes = formatted_data.map.with_index { |x, idx| idx if x.keys && x.keys[0] == :dates }.compact_blank
      return formatted_data unless indexes.size > 1

      first = formatted_data[0...(indexes[-1])]
      last = formatted_data[indexes[-1]..-1]

      [first, last]
    end

    def financial_rows
      partitioned_rows&.first
    end

    def innovation_rows
      partitioned_rows&.last
    end

    FIRST_TABLE_ROWS = %i[dates employees total_turnover exports uk_sales net_profit total_net_assets].freeze
    SECOND_TABLE_ROWS = %i[dates units_sold sales sales_exports sales_royalties avg_unit_price avg_unit_cost_self].freeze

    def header_full_award_type
      "Innovation Award"
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

      start_new_page
      render_innovation_financial_table
    end

    def render_innovation_financial_table
      render_text_line("Innovation Financials", 2, style: :bold)

      ps = []
      ps << "Where relevant to their innovation, the applicant provided additional information to help us understand the financial value of their innovation. Innovations are defined as per the gov.uk guidance. For the avoidance of doubt, accountants are not asked to apply judgement in determining whether the financial values disclosed meet the requirements for an innovation award. This is left to the sole discretion of The Queen’s Award Office."

      ps << "Figures derived from financial statements should be based upon the Generally Accepted Accounting Principles (‘GAAP’) used by the company. A parent company making a group entry should include the trading figures of all UK members of the group (‘The UK business’)."

      ps.each { |pr| render_text_line(pr, 2) }

      render_accountant_guidance_general_notes

      start_at_idx = FIRST_TABLE_ROWS.length + 1

      rows = SECOND_TABLE_ROWS.each_with_object([]).with_index(start_at_idx) do |(field, memo), index|
        row = innovation_rows.detect { |r| r[field] }

        next unless row

        memo << if field == :dates
          render_date_row(row, index)
        else
          render_financial_row(row, index, key: field)
        end

        memo << revised_row(row.values.first.length, index)
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
      render_text_line("The UK Business Financials", 2, style: :bold)

      rows = FIRST_TABLE_ROWS.each_with_object([]).with_index(1) do |(field, memo), index|
        row = financial_rows.detect { |r| r[field] }
        
        next unless row
        
        memo << if field == :dates
          render_date_row(row, index)
        elsif field == :uk_sales
          render_financial_uk_sales_row(row, index)
        else
          render_financial_row(row, index, key: field)
        end

        memo << revised_row(row.values.first.length, index)
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
