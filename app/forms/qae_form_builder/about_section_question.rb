class QAEFormBuilder
  class AboutSectionQuestionValidator < HeaderQuestionValidator
  end

  class AboutSectionQuestionBuilder < HeaderQuestionBuilder
    def section ref
      data = section_data ref

      @q.context = data.map {|d| form_context(d)}.join

      @q.pdf_context_with_header_blocks = data.map {|d| pdf_context(d)}.flatten(1)
    end

    private
    def form_context(data)
      %(
        <h3 class="govuk-heading-m">#{data.header}</h3>
        #{data.context.map { |c| "<p class='govuk-body'>#{c}</p>" }.join}
      )
    end

    def pdf_context(data)
      [
        [:bold, data.header],
        [:normal, data.context.map { |c| c.gsub(/<br\s*\/?>/, '')}.join("\n\n")]
      ]
    end

    def section_data(ref)
      case ref
      when "due_diligence"
        [about_section_A]
      when "company_information"
        [about_section_B, small_organisations]
      when "your_innovation"
        [about_section_C_innovation, word_limits, technical_language, supplementary_materials]
      when "innovation_commercial_performance"
        [about_section_D_innovation, financial_periods, estimated_figures]
      when "company_financials"
        [group_entries, required_figures_innovation, figures_format]
      when "innovation_financials"
        [about_D6, required_figures_innovation, figures_format]
      when "innovation_ESG"
        [about_section_E, answering_questions_innovation, small_organisations]
      when "your_international_trade"
        [about_section_C_international_trade, small_organisations, covid_impact, word_limits, technical_language, supplementary_materials]
      when "trade_commercial_performance"
        [about_section_D_trade, financial_periods_trade, estimated_figures]
      when "company_financials_trade"
        [group_entries, required_figures_trade, figures_format]
      end
    end

    # Section A
    def about_section_A
      OpenStruct.new(
        :header => "About section A",
        :context => [
          "This section is to confirm that you have the authorisation to apply, that your organisation's past and present conduct would not cause reputational damage to the Awards, and what will happen after you apply in terms of due diligence and verification of commercial figures. We recommend you carefully answer section A questions before proceeding with the rest of the application.",
        ]
      )
    end

    # Section B
    def about_section_B
      OpenStruct.new(
        :header => "About section B",
        :context => [
          "The purpose of this section is to collect specific information about your organisation. It is important that the details are accurate as they cannot be changed after the submission deadline.",
          "This information will help us to identify your organisation and will also enable us to undertake due diligence checks with other Government Departments and Agencies if your application is shortlisted.",
        ]
      )
    end

    def small_organisations
      OpenStruct.new(
        :header => "Small organisations",
        :context => [
          "The King's Awards for Enterprise is committed to acknowledging the efforts of organisations of all sizes. When assessing, we consider the size and sector of your organisation. If you are a small organisation, do not be intimidated by the questions that are less relevant to you - answer all questions to the degree you can.",
        ]
      )
    end

    # Section C
    def about_section_C_innovation
      OpenStruct.new(
        :header => "About section C",
        :context => [
          "This section is structured to enable you to tell your success story of the innovation's development, implementation and impact, enabling the assessing team to understand the role innovation plays within your overall business and how this impacts the performance of your business."
        ]
      )
    end

    def about_section_C_international_trade
      OpenStruct.new(
        :header => "About section C",
        :context => [
          "The purpose of this section is to enable the assessing team to understand your company, its product, services, and the role exporting plays within your overall business. We need to understand how this impacts the overall performance of your business."
        ]
      )
    end

    def covid_impact
      OpenStruct.new(
        :header => "COVID-19 impact",
        :context => [
          "If your growth was affected by COVID-19, this would be taken into consideration during the assessment process. Question C5 asks you to explain how your organisation responded to these challenges."
        ]
      )
    end

    def word_limits
      OpenStruct.new(
        :header => "Word limits",
        :context => [
          "What matters most is the quality of the information and insight you provide. The word limits for each question are just there to stop your application from becoming overlong and give an idea of the relative level of detail the assessors are looking for."
        ]
      )
    end

    def technical_language
      OpenStruct.new(
        :header => "Technical language",
        :context => [
          "Please avoid using technical language - we need to understand your answers without having specific knowledge of your industry. If you use acronyms, please define them when you use them for the first time."
        ]
      )
    end

    def supplementary_materials
      OpenStruct.new(
        :header => "Supplementary materials",
        :context => [
          "To support your answers in this section, you can add up to three materials (documents or online links) in Section F. For assessors to review them, you must reference them by their names in your answers.",
          "Assessors have limited time to evaluate your application, so any additional documents should be kept short and relevant. Do not use them as a substitute for providing narrative answers to the questions."
        ]
      )
    end

    # Section D
    def about_section_D_innovation
      OpenStruct.new(
        :header => "About section D",
        :context => [
          "All applicants must demonstrate a certain level of financial performance. This section enables you to show the impact that your innovation has had on your organisation's financial performance. Financial information must be supplied so your organisation's commercial performance can be evaluated. It is important that these details are accurate, as you will need to verify them if shortlisted.",
          "We recommend you get your accountant to assist you with this section."
        ]
      )
    end

    def about_section_D_trade
      OpenStruct.new(
        :header => "About section D",
        :context => [
          "All applicants must demonstrate a certain level of financial performance. This section enables you to show the impact that your international trade has had on your organisation's financial performance. Financial information must be supplied so your organisation's commercial performance can be evaluated. It is important that these details are accurate, as you will need to verify them if shortlisted.",
          "We recommend you get your accountant to assist you with this section."
        ]
      )
    end

    def financial_periods
      OpenStruct.new(
        :header => "Periods the figures are required for",
        :context => [
          "We ask you to provide figures for your five most recent financial years. If you started trading within the last five years, you only need to provide figures for the years you have been trading. However, to meet minimum eligibility requirements, you must be able to provide figures for at least your two most recent financial years, covering the full 24 months.",
          "For the purpose of this application, your most recent financial year is your last financial year ending before the #{Settings.current.deadlines.where(kind: "submission_end").first.decorate.formatted_trigger_date('with_year')} - the application submission deadline."
        ]
      )
    end

    def financial_periods_trade
      OpenStruct.new(
        :header => "Periods the figures are required for",
        :context => [
          "Depending on which award you are applying for, you must be able to provide financial figures for your three most recent financial years, covering exactly 36 consecutive months; or if you are applying for a 6-year award (see question D1), you must provide figures for the last six financial years, covering exactly 72 consecutive months.",
          "For the purpose of this application, your most recent financial year is your last financial year ending before the #{Settings.current.deadlines.where(kind: "submission_end").first.decorate.formatted_trigger_date('with_year')} - the application submission deadline.",
          "If you have changed your year-end during the period of your application, see D2.3 for an explanation of how this must be dealt with."
        ]
      )
    end


    def estimated_figures
      OpenStruct.new(
        :header => "Estimated figures",
        :context => [
          "If you haven't reached or finalised accounts for your most recent financial year, you can provide estimated figures for now.",
          "If you are shortlisted, you will have to provide the actual figures that have been verified before the specified November deadline (the exact date will be provided in the shortlisting email). Typically, the verification is done by an external accountant who prepares your annual accounts or returns or, in the case of a larger organisation, who conducts your financial audit."
        ]
      )
    end

    def group_entries
      OpenStruct.new(
        :header => "Group entries",
        :context => [
          "A parent company making a group entry should include the trading figures of all UK members of the group."
        ]
      )
    end

    def required_figures_innovation
      OpenStruct.new(
        :header => "Required figures",
        :context => [
          "We ask you to provide figures for your five most recent financial years. If you started trading within the last five years, you only need to provide figures for the years you have been trading. However, to meet minimum eligibility requirements, you must be able to provide figures for at least your two most recent financial years, covering the full 24 months.",
          "If you haven't reached your latest year-end, please use estimates to complete these questions."
        ]
      )
    end

    def required_figures_trade
      OpenStruct.new(
        :header => "Required figures",
        :context => [
          "If you have selected “Outstanding Short-Term Growth” in D1, you will only need to provide information for the last three years.",
          "If you haven't reached your latest year-end, please use estimates to complete these questions."
        ]
      )
    end

    def figures_format
      OpenStruct.new(
        :header => "Figures - format",
        :context => [
          "You must enter financial figures in pounds sterling (£).<br>
          Round the figures to the nearest pound (do not enter pennies).<br>
          Do not separate your figures with commas.<br>
          Use a minus symbol to record any losses.<br>
          Enter '0' if you had none."
        ]
      )
    end

    def about_D6
      OpenStruct.new(
        :header => "About D6 questions",
        :context => [
          "Some of the details may not apply to your innovation. Answer the questions that are relevant to help us understand the financial value of your innovation."
        ]
      )
    end

    # Section E
    def about_section_E
      OpenStruct.new(
        :header => "About section E",
        :context => [
          "The environmental, social, and corporate governance (ESG) section is an opportunity for you to highlight your responsible business conduct and its impact within your organisation, supply chain and the wider community.",
          "We expect all King's Award for Enterprise applicants to adhere to commonly accepted standards for environmentally and socially responsible corporate governance. Failure to demonstrate that will result in your application not being successful."
        ]
      )
    end

    def answering_questions_innovation
      OpenStruct.new(
        :header => "Answering questions",
        :context => [
          "Provide examples for each question relative to the size and scale of your business.",
          "The word limits are a guide. You do not need to maximise the word limit if there is no reason to - we suggest you focus on your strongest examples in each case.",
          "Furthermore, you may have already answered some of the questions in this section in other parts of the form. If you believe this is the case, you do not need to repeat the information but make it clear by referencing the questions in other parts of the form.",
          "The guidance notes below each section are not exhaustive. Where possible, please support your answers with quantitative evidence of your initiatives, improvements and successes, and describe any relevant policies or procedures that you have in place.",
          "Finally, there is no need to provide information on how you are adhering to statutory laws or regulations - such as 'we pay minimum wage'. We're more interested in how you are going above and beyond."
        ]
      )
    end
  end

  class AboutSectionQuestion < HeaderQuestion
  end
end
