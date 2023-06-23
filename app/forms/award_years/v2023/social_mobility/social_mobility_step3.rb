# -*- coding: utf-8 -*-
class AwardYears::V2023::QaeForms
  class << self
    def mobility_step3
      @mobility_step3 ||= proc do
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
            )]
          ]
        end

        textarea :commercial_performance_description, "How would you describe your organisation's financials?" do
          sub_ref "C 1"
          required
          context %(
            <p>To be eligible for a Queen's Award for Enterprise, your organisation must be on a sustainable financial footing.</p>
          )
          rows 5
          words_max 250
        end

        innovation_financial_year_date :financial_year_date, "Enter your financial year-end date." do
          ref "C 2"
          required
          financial_date_pointer
        end

        options :financial_year_date_changed, "Did your year-end date change in the last three-years?" do
          classes "sub-question js-financial-year-change"
          sub_ref "C 2.1"
          required
          yes_no
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

        one_option_by_years_label :financial_year_changed_dates, "Enter your year-end dates for each financial year." do
          classes "sub-question one-option-by-years"
          sub_ref "C 2.2"
          required
          context %(
            <p>Typically, you would have to submit data for your latest financial year that falls before the #{Settings.current.deadlines.where(kind: "submission_end").first.decorate.formatted_trigger_date('with_year')} (the submission deadline). However, if your latest financial performance has been affected by the volatile market conditions due to factors such as Covid, you may wish to use your last financial year before Covid. For example, if your year-end is 31 January 2022, you may want to use the financial year ending 31 January 2020 for your final set of financial figures.</p>

            <p>If you are providing estimated figures for the current year and do not yet have the financial statements to support these, if you are shortlisted, you may be asked to provide the actual figures and the latest year's VAT returns by October/November.</p>
          )
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
          ref "C 3"
          classes "question-employee-min"
          required
          context %(
            <p>You can use the number of full-time employees at the year-end, or the average for the twelve-month period. Part-time employees should be expressed in full-time equivalents (FTEs).</p>
          )
          type :number
          label ->(y) { "Financial year #{y}" }

          conditional :financial_year_date_changed, :true
          employees_question
        end

        header :financials, "Financials" do
          ref "C 4"
          context %(
            <h3 class="govuk-heading-m govuk-!-margin-bottom-1">Group entries</h3>
            <p class="govuk-body">A parent organisation making a group entry should include figures of all UK members of the group.</p>

            <h3 class="govuk-heading-m govuk-!-margin-bottom-1">Estimated figures</h3>
            <p class="govuk-body">If you are providing estimated figures for the current year and do not yet have the financial statements to support these, if you are shortlisted, you may be asked to provide the actual figures and the latest year's VAT returns by October/November.</p>

            <h3 class="govuk-heading-m govuk-!-margin-bottom-1">Figures - format</h3>
            <p class="govuk-body">You must enter financial figures in pounds sterling (£). Round the figures to the nearest pound (do not enter pennies). Do not separate your figures with commas.</p>
          )
          pdf_context_with_header_blocks [
            [:bold, "Group entries"],
            [:normal, %(
              A parent organisation making a group entry should include figures of all UK members of the group.
            )],
            [:bold, "Estimated figures"],
            [:normal, %(
              If you are providing estimated figures for the current year and do not yet have the financial statements to support these, if you are shortlisted, you may be asked to provide the actual figures and the latest year's VAT returns by October/November.
            )],
            [:bold, "Figures - format"],
            [:normal, %(
              You must enter financial figures in pounds sterling (£). Round the figures to the nearest pound (do not enter pennies). Do not separate your figures with commas.
            )]
          ]
        end

        one_option_by_years :total_turnover, "Total income or turnover" do
          classes "sub-question"
          ref "C 4.1"
          required
          context %(
            <p>If you are a charity, please provide your total income figures; if you are a company, please provide your turnover figures.</p>
            <p>If you haven't reached your latest year-end, please use estimates to complete this question.</p>
          )

          type :money
          label ->(y) { "Financial year #{y}" }

        end

        one_option_by_years :net_profit, "Net income or net profit after tax but before dividends" do
          classes "sub-question"
          sub_ref "C 4.2"
          required
          context %(
            <p>If you are a charity, please provide your net income figures; if you are a company, please provide your net profit after tax but before dividends figures.</p>
            <p>Use a minus symbol to record any losses.</p>
          )

          type :money
          label ->(y) { "Financial year #{y}" }
        end

        one_option_by_years :total_net_assets, "Total net assets" do
          classes "sub-question total-net-assets"
          sub_ref "C 4.3"
          required
          context "<p>As per your balance sheet. Total assets (fixed and current), minus liabilities (current and long-term).</p>"
          type :money
          label ->(y) { "As at the end of year #{y}" }

        end

        textarea :drops_in_turnover, "Explain any drops in the total income or turnover, net income or net profit and total net assets and any losses made." do
          classes "sub-question"
          sub_ref "C 4.4"
          required
          context %(
            <p>Sustained or unexplained drops or losses may lead to the entry being rejected.</p>
            <p>Answer this question if you have any dips or losses in total income/turnover, net income/profits or total net assets. If you didn't have any drops or losses, please state so.</p>
          )
          rows 5
          words_max 300
        end

        textarea :drops_explain_how_your_business_is_financially_viable, "Explain how your organisation is financially viable." do
          classes "sub-question"
          sub_ref "C 4.5"
          required
          context %(
            <p>For example, explain:</p>
            <ul>
              <li>How you are funded;</li>
              <li>If you have received any form of investment or funding, if so, please specify the amounts;</li>
              <li>How you plan to sustain your organisation in future (if you have an investment or funding strategy, please set out its objectives).</li>
            </ul>
            <p>This information is particularly useful when ascertaining your company's financial viability, especially when you have drops in total turnover and losses.</p>
          )
          pdf_context %(
            For example, explain:

            \u2022 How you are funded;

            \u2022 If you have received any form of investment or funding, if so, please specify the amounts;

            \u2022 How you plan to sustain your organisation in future (if you have an investment or funding strategy, please set out its objectives).

            This information is particularly useful when ascertaining your company's financial viability, especially when you have drops in total turnover and losses.
          )
          rows 5
          words_max 300
        end

        textarea :covid_impact_details, "Explain how your business has been responding to volatile markets in recent years." do
          ref "C 5"
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
          ref "C 6"
          required
          context %(
            <p>If you are providing estimated figures for the current year and do not yet have the financial statements to support these, if you are shortlisted, you may be asked to provide the actual figures and the latest year's VAT returns by October/November.</p>
          )
          yes_no
        end

        textarea :product_estimates_use, "Explain the use of estimates, and how much of these are actual receipts or firm orders." do
          classes "sub-question"
          sub_ref "C 6.1"
          required
          rows 5
          words_max 250
          conditional :product_estimated_figures, :yes
        end

      end
    end
  end
end
