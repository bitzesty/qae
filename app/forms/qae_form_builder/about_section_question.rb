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
      end
    end
  end

  class AboutSectionQuestion < HeaderQuestion
  end
end
