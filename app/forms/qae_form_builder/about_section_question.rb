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
        [:normal, data.context.join("\n")]
      ]
    end

    def section_data(ref)
      case ref
      when "A"
        [OpenStruct.new(
          :header => "About section A",
          :context => [
            "This section is to confirm that you have the authorisation to apply, that your organisation's past and present conduct would not cause reputational damage to the Awards, and what will happen after you apply in terms of due diligence and verification of commercial figures. We recommend you carefully answer section A questions before proceeding with the rest of the application.",
          ]
        )]
      when "B"
        [OpenStruct.new(
          :header => "About section B",
          :context => [
            "The purpose of this section is to collect specific information about your organisation. It is important that the details are accurate as they cannot be changed after the submission deadline.",
            "This information will help us to identify your organisation and will also enable us to undertake due diligence checks with other Government Departments and Agencies if your application is shortlisted.",
          ]
        ), OpenStruct.new(
          :header => "Small organisations",
          :context => [
            "The King's Awards for Enterprise is committed to acknowledging the efforts of organisations of all sizes. When assessing, we consider the size and sector of your organisation. If you are a small organisation, do not be intimidated by the questions that are less relevant to you - answer all questions to the degree you can.",
          ]
        )]
      when "C-innovation"
        [OpenStruct.new(
          :header => "About section C",
          :context => [
            "This section is structured to enable you to tell your success story of the innovation's development, implementation and impact, enabling the assessing team to understand the role innovation plays within your overall business and how this impacts the performance of your business."
          ]
        ), OpenStruct.new(
          :header => "Word limits",
          :context => [
            "What matters most is the quality of the information and insight you provide. The word limits for each question are just there to stop your application from becoming overlong and give an idea of the relative level of detail the assessors are looking for."
          ]
        ), OpenStruct.new(
          :header => "Technical language",
          :context => [
            "Please avoid using technical language - we need to understand your answers without having specific knowledge of your industry. If you use acronyms, please define them when you use them for the first time."
          ]
        ), OpenStruct.new(
          :header => "Supplementary materials",
          :context => [
            "To support your answers in this section, you can add up to three materials (documents or online links) in Section F. For assessors to review them, you must reference them by their names in your answers.",
            "Assessors have limited time to evaluate your application, so any additional documents should be kept short and relevant. Do not use them as a substitute for providing narrative answers to the questions."
          ]
        )]
      end
    end
  end

  class AboutSectionQuestion < HeaderQuestion
  end
end
