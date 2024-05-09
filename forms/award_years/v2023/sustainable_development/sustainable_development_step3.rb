class AwardYears::V2023::QaeForms
  class << self
    def development_step3
      @development_step3 ||= proc do
        header :commercial_success_info_block, "" do
          section_info
          context %(
            <h3 class="govuk-heading-m">About this section</h3>
            <p class="govuk-body">
              All applicants must demonstrate their viability and you will need to upload your accounts to provide evidence of this.
            </p>

            <h3 class="govuk-heading-m">Small organisations</h3>
            <p class="govuk-body">
              The Queen's Awards for Enterprise is committed to acknowledging efforts of organisations of all sizes. When assessing, we consider the size and sector of your organisation. If you are a small organisation, do not be intimidated by the questions that are less relevant to you - answer all of the questions to a degree you can.
            </p>

            <h3 class="govuk-heading-m">Volatile markets & last financial year</h3>
            <p class="govuk-body">
              We recognise that recent volatile market conditions might have affected your growth plans. We will take this into consideration during the assessment process.
            </p>
            <p class="govuk-body">
              Also, typically, you would have to submit data for your last financial year that falls before #{Settings.current.deadlines.where(kind: "submission_end").first.decorate.formatted_trigger_date('with_year')} (the submission deadline). However, if your latest financial performance has been affected by the volatile market conditions due to factors such as Covid, you may wish to use your last financial year before Covid. For example, if your year-end is 31 January 2022, you may want to use the financial year ending 31 January 2020 for your final set of financial figures.
            </p>
            <h3 class="govuk-heading-m">Estimated figures</h3>
            <p class="govuk-body">
              Please note, if you are providing estimated figures for the current year and do not yet have the financial statements to support these, if you are shortlisted, you may be asked to provide the actual figures and the latest year's VAT returns by October/November.
            </p>
          )
          pdf_context_with_header_blocks [
            [:bold, "About this section"],
            [:normal, %(
              All applicants must demonstrate their viability and you will need to upload your accounts to provide evidence of this.
            )],
            [:bold, "Small organisations"],
            [:normal, %(
              The Queen's Awards for Enterprise is committed to acknowledging efforts of organisations of all sizes. When assessing, we consider the size and sector of your organisation. If you are a small organisation, do not be intimidated by the questions that are less relevant to you - answer all of the questions to a degree you can.
            )],
            [:bold, "Volatile markets & last financial year"],
            [:normal, %(
              We recognise that recent volatile market conditions might have affected your growth plans. We will take this into consideration during the assessment process.

              Also, typically, you would have to submit data for your last financial year that falls before #{Settings.current.deadlines.where(kind: "submission_end").first.decorate.formatted_trigger_date('with_year')} (the submission deadline).However, if your latest financial performance has been affected by the volatile market conditions due to factors such as Covid, you may wish to use your last financial year before Covid. For example, if your year-end is 31 January 2022, you may want to use the financial year ending 31 January 2020 for your final set of financial figures.
            )],
            [:bold, "Estimated figures"],
            [:normal, %(
              Please note, if you are providing estimated figures for the current year and do not yet have the financial statements to support these, if you are shortlisted, you may be asked to provide the actual figures and the latest year's VAT returns by October/November.
            )],
          ]
        end

        textarea :explain_why_your_organisation_is_financially_viable, "Explain why your organisation is financially viable." do
          ref "C 1"
          required
          context %(
            <p>
              For example, you could briefly explain your financial model, income or profit growth, how you are funded, your cash flow position and investments secured. Some of these may not apply to your organisation, in that case, explain by what other means your organisation ensures financial viability.
            </p>
          )
          rows 5
          words_max 250
        end

        innovation_financial_year_date :financial_year_date, "Please enter your financial year end date." do
          ref "C 2"
          required
          financial_date_pointer
        end

        options :financial_year_date_changed, "Did your year-end date change during your <span class='js-entry-period-subtext'>3</span> year entry period?" do
          classes "sub-question js-financial-year-change"
          sub_ref "C 2.1"
          required
          yes_no
          context %(
            <p>
              We ask this to obtain all of the commercial figures we need to assess your application. You should ensure that any data supporting your application covers <span class='js-entry-period-subtext'>3</span> full 12-month periods.
            </p>
          )
          default_option "no"
        end

        textarea :financial_year_date_changed_explaination, "Please explain why your year-end date changed." do
          classes "sub-question"
          sub_ref "C 2.1.1"
          required
          rows 2
          words_max 100
          conditional :financial_year_date_changed, :yes
        end

        one_option_by_years_label :financial_year_changed_dates, "Please enter your year-end dates for each financial year." do
          classes "sub-question one-option-by-years"
          sub_ref "C 2.2"

          context %(
            <p>
              Typically, you would have to submit data for your latest financial year that falls before the #{Settings.current.deadlines.where(kind: "submission_end").first.decorate.formatted_trigger_date('with_year')} (the submission deadline). However, if your latest financial performance has been affected by the volatile market conditions due to factors such as Covid, you may wish to use your last financial year before Covid. For example, if your year-end is 31 January 2022, you may want to use the financial year ending 31 January 2020 for your final set of financial figures.
            </p>
            <p>
              If you are providing estimated figures for the current year and do not yet have the financial statements to support these, if you are shortlisted, you may be asked to provide the actual figures and the latest year's VAT returns by October/November.
            </p>
          )

          required
          type :date
          label ->(y) { "Financial year #{y}" }
        end

        upload :supporting_financials, "To support your figures, please upload your financial statements for the years entered in question C2.2." do
          classes "sub-question"
          sub_ref "C 2.3"
          context %(
            <p>
              If you are a company, upload relevant accounts as submitted to the Companies House. In addition, upload the full accounts prepared by your company and your corporation tax returns as submitted to HMRC.
            </p>
            <p>
              If you are a Charity, upload relevant returns as submitted to the Charity Commission.
            </p>
            <p>
              If you are a sole trader or unincorporated partnership, upload relevant accounts and your tax returns as submitted to HMRC.
            </p>
            <p>
              Please note, if you are providing estimated figures for the current year and do not yet have the financial statements to support these, if you are shortlisted, you may be asked to provide the actual figures and the latest year's VAT returns by October/November.
            </p>
            <p>
              You can upload files in most common formats, if they are less than five megabytes.
            </p>
          )
          hint "What are the accepted file formats?", %(
            <p>
              You can upload any of the following file formats: chm, csv, diff, doc, docx, dot, dxf, eps, gif, gml, ics, jpg, kml, odp, ods, odt, pdf, png, ppt, pptx, ps, rdf, rtf, sch, txt, wsdl, xls, xlsm, xlsx, xlt, xml, xsd, xslt, zip.
            </p>
          )
          max_attachments 15
        end

        one_option_by_years :employees, "Enter the number of people employed by your organisation in the UK in each year of your entry." do
          classes "question-employee-min"
          ref "C 3"
          required
          context %(
            <p>You can use the number of full-time employees at the year-end, or the average for the 12 month period. Part-time employees should be expressed in full-time equivalents. </p>
          )
          type :number
          label ->(y) { "Financial year #{y}" }

          conditional :financial_year_date_changed, :true

          employees_question
        end

        header :company_financials, "Company Financials" do
          ref "C 4"
          context %(
            <p class="govuk-body">
              A parent company making a group entry should include the trading figures of all UK members of the group.
            </p>
            <p class="govuk-body">
              You must enter actual financial figures in £ sterling (ignoring pennies).
            </p>
            <p class="govuk-body">
              Please do not separate your figures with commas.
            </p>
          )
        end

        one_option_by_years :total_turnover, "Total turnover" do
          ref "C 4.1"
          required
          classes "sub-question"

          type :money
          label ->(y) { "Financial year #{y}" }

          conditional :financial_year_date_changed, :true
        end

        one_option_by_years :exports, "Of which exports" do
          classes "sub-question"
          sub_ref "C 4.2"
          required
          context %(<p>Please enter '0' if you had none.</p>)

          type :money
          label ->(y) { "Financial year #{y}" }

          conditional :financial_year_date_changed, :true
        end

        # UK sales = turnover - exports
        turnover_exports_calculation :uk_sales, "Of which UK sales" do
          classes "sub-question"
          sub_ref "C 4.3"
          label ->(y) { "Financial year #{y}" }

          conditional :financial_year_date_changed, :true
          turnover :total_turnover
          exports :exports
          one_option_financial_data_mode true

          context %(
            <p>
              This number is automatically calculated using your total turnover and export figures.
            </p>
          )
        end

        one_option_by_years :net_profit, "Net profit after tax but before dividends (UK and overseas)" do
          classes "sub-question"
          sub_ref "C 4.4"
          required

          type :money
          label ->(y) { "Financial year #{y}" }

          context %(
            <p>
              Use a minus symbol to record any losses.
            </p>
          )

          conditional :financial_year_date_changed, :true
        end

        one_option_by_years :total_net_assets, "Total net assets" do
          classes "sub-question total-net-assets"
          sub_ref "C 4.5"
          required
          context %(
            <p>
              As per your balance sheet. Total assets (fixed and current) minus liabilities (current and long-term).
            </p>
          )
          type :money
          label ->(y) { "As at the end of year #{y}" }

          conditional :financial_year_date_changed, :true
        end

        textarea :drops_in_turnover, "Explain any drops in turnover, export sales, total net assets and net profits, as well as any losses made." do
          classes "sub-question"
          sub_ref "C 4.6"
          required
          rows 5
          words_max 200

          context %(
            <p>
              If you didn't have any drops in the total turnover, export sales, total net assets or net profit, or any losses, please state so.
            </p>
          )
        end

        textarea :development_performance, "What cost-savings have you or your customers' businesses made or will make as a result of the introduction of your sustainable development actions or interventions? If none, please state so." do
          ref "C 5"
          required
          context %(
            <p>
              Provide figures and describe cost-savings and other benefits in addition to the sustainability impact you have already demonstrated in section B of this form.
            </p>
          )
          rows 5
          words_max 250
        end

        textarea :investments_details, "Please enter details of all investments and reinvestments (capital and operating costs) in your sustainable development actions or interventions. If none, please state so." do
          ref "C 6"
          required
          context %(
            <p>
              Include all investments and reinvestments made both during and before your entry period. Also, include the year(s) in which they were made.
            </p>
          )
          rows 5
          words_max 400
        end

        textarea :covid_impact_details, "Explain how your business has been responding to volatile markets in recent years." do
          ref "C 7"
          required
          context %(
            <p>
              How have you adapted to or mitigated the impacts of recent volatile markets due to factors such as Covid, and with what results? How are you planning to respond in the year ahead? This could include opportunities you have identified as well as any contextual information or challenges you would like the assessors to consider.
            </p>
          )
          rows 4
          words_max 350
        end

        options :product_estimated_figures, "Are any of the figures used on this page estimates?" do
          ref "C 8"
          required
          yes_no
          context %(
            <p>
              If you are providing estimated figures for the current year and do not yet have the financial statements to support these, if you are shortlisted, you may be asked to provide the actual figures and the latest year's VAT returns by October/November.
            </p>
          )
          conditional :financial_year_date_changed, :true
        end

        textarea :product_estimates_use, "Explain the use of estimates, and how much of these are actual receipts or firm orders." do
          classes "sub-question"
          sub_ref "C 8.1"
          required
          rows 5
          words_max 250
          conditional :product_estimated_figures, :yes
        end

      end
    end
  end
end
