class AppraisalForm

  #
  # THIS NEED TO BE UPDATED EACH YEAR
  #
  SUPPORTED_YEARS = [2016, 2017]

  RAG_OPTIONS_2016 = [
    %w(Red negative),
    %w(Amber average),
    %w(Green positive)
  ]

  RAG_OPTIONS_2017 = [
    %w(Red negative),
    %w(Amber average),
    %w(Green positive)
  ]

  CSR_RAG_OPTIONS_2016 = [
    ["Weak (0-15)", "negative"],
    ["Satisfactory (16-31)", "average"],
    ["Exceptional (32-50)", "positive"]
  ]

  CSR_RAG_OPTIONS_2017 = [
    ["Weak (0-15)", "negative"],
    ["Satisfactory (16-31)", "average"],
    ["Exceptional (32-50)", "positive"]
  ]

  STRENGTH_OPTIONS_2016 = [
    ["Insufficient Information Supplied", "neutral"],
    ["Priority Focus for Development", "negative"],
    ["Positive - Scope for Ongoing Development", "average"],
    ["Key Strength", "positive"]
  ]

  STRENGTH_OPTIONS_2017 = [
    ["Insufficient Information Supplied", "neutral"],
    ["Priority Focus for Development", "negative"],
    ["Positive - Scope for Ongoing Development", "average"],
    ["Key Strength", "positive"]
  ]

  VERDICT_OPTIONS_2016 = [
    ["Not Recommended", "negative"],
    ["Reserved", "average"],
    ["Recommended", "positive"]
  ]

  VERDICT_OPTIONS_2017 = [
    ["Not Recommended", "negative"],
    ["Reserved", "average"],
    ["Recommended", "positive"]
  ]

  def self.rag_options_for(object, section)
    options = if section.desc.include?("corporate_social_responsibility")
      const_get("CSR_RAG_OPTIONS_#{object.award_year.year}")
    else
      const_get("RAG_OPTIONS_#{object.award_year.year}")
    end

    option = options.detect do |opt|
      opt[1] == object.public_send(section.rate)
    end || ["Select RAG", "blank"]

    OpenStruct.new(
      options: options,
      option: option
    )
  end

  def self.non_rag_options_for(object, section)
  end

  def self.strength_options_for(object, section)
    year = object.award_year.year

    options = const_get("STRENGTH_OPTIONS_#{year}")

    option = options.detect do |opt|
      opt[1] == object.public_send(section.rate)
    end || ["Select Key Strengths and Focuses", "blank"]

    OpenStruct.new(
      options: options,
      option: option
    )
  end

  def self.verdict_options_for(object, section)
    options = const_get("VERDICT_OPTIONS_#{object.award_year.year}")

    option = options.detect do |opt|
      opt[1] == object.public_send(section.rate)
    end || ["Select verdict", "blank"]

    OpenStruct.new(
      options: options,
      option: option
    )
  end

  RAG_ALLOWED_VALUES = [
    "negative",
    "average",
    "positive"
  ]

  NON_RAG_ALLOWED_VALUES = [
    "negative",
    "average",
    "positive"
  ]

  STRENGTHS_ALLOWED_VALUES = [
    "neutral",
    "negative",
    "average",
    "positive"
  ]

  VERDICT_ALLOWED_VALUES = [
    "negative",
    "average",
    "positive"
  ]

  TRADE_2016 = {
    overseas_earnings_growth: {
      type: :rag,
      label: "Overseas earnings growth:",
      position: 0
    },
    commercial_success: {
      type: :rag,
      label: "Commercial success:",
      position: 1
    },
    strategy: {
      type: :rag,
      label: "Strategy:",
      position: 2
    },
    verdict: {
      type: :verdict,
      label: "Overall verdict:",
      position: 3
    }
  }

  TRADE_2017 = {
    overseas_earnings_growth: {
      type: :rag,
      label: "Overseas earnings growth:",
      position: 0
    },
    commercial_success: {
      type: :rag,
      label: "Commercial success:",
      position: 1
    },
    strategy: {
      type: :rag,
      label: "Strategy:",
      position: 2
    },
    corporate_social_responsibility: {
      type: :rag,
      label: "Corporate social responsibility (section D):",
      position: 3
    },
    verdict: {
      type: :verdict,
      label: "Overall verdict:",
      position: 4
    }
  }

  INNOVATION_2016 = {
    level_of_innovation: {
      type: :rag,
      label: "Level of innovation:",
      position: 0
    },
    extent_of_value_added: {
      type: :rag,
      label: "Extent of value added:",
      position: 1
    },
    impact_of_innovation: {
      type: :rag,
      label: "Impact of innovation:",
      position: 2
    },
    verdict: {
      type: :verdict,
      label: "Overall verdict:",
      position: 3
    }
  }

  INNOVATION_2017 = {
    level_of_innovation: {
      type: :rag,
      label: "Level of innovation:",
      position: 0
    },
    extent_of_value_added: {
      type: :rag,
      label: "Extent of value added:",
      position: 1
    },
    impact_of_innovation: {
      type: :rag,
      label: "Impact of innovation:",
      position: 2
    },
    corporate_social_responsibility: {
      type: :rag,
      label: "Corporate social responsibility (section D):",
      position: 3
    },
    verdict: {
      type: :verdict,
      label: "Overall verdict:",
      position: 4
    }
  }

  PROMOTION_2016 = {
    nature_of_activities: {
      type: :rag,
      label: "Nature (breadth) of activities:",
      position: 0
    },
    impact_achievement: {
      type: :rag,
      label: "Impact/achievement:",
      position: 1
    },
    level_of_support: {
      type: :rag,
      label: "Level of support:",
      position: 2
    },
    verdict: {
      type: :verdict,
      label: "Overall verdict:",
      position: 3
    }
  }

  PROMOTION_2017 = {
    nature_of_activities: {
      type: :rag,
      label: "Nature (breadth) of activities:",
      position: 0
    },
    impact_achievement: {
      type: :rag,
      label: "Impact/achievement:",
      position: 1
    },
    level_of_support: {
      type: :rag,
      label: "Level of support:",
      position: 2
    },
    corporate_social_responsibility: {
      type: :rag,
      label: "Corporate social responsibility (section D):",
      position: 3
    },
    verdict: {
      type: :verdict,
      label: "Overall verdict:",
      position: 4
    }
  }

  DEVELOPMENT_2016 = {
    product_service_contribution: {
      type: :rag,
      label: "Product/service contribution:",
      position: 0
    },
    commercial_success: {
      type: :rag,
      label: "Commercial success:",
      position: 1
    },
    strategy: {
      type: :rag,
      label: "Strategy:",
      position: 2
    },
    environment: {
      type: :non_rag,
      label: "Environmental dimension:",
      position: 3
    },
    social: {
      type: :non_rag,
      label: "Social dimension:",
      position: 4
    },
    economic: {
      type: :non_rag,
      label: "Economic dimension:",
      position: 5
    },
    leadership_management: {
      type: :non_rag,
      label: "Leadership & management:",
      position: 6
    },
    environment_protection: {
      type: :strengths,
      label: "Environmental protection and management:",
      position: 7
    },
    benefiting_the_wilder_community: {
      type: :strengths,
      label: "Benefiting the wider community:",
      position: 8
    },
    sustainable_resource: {
      type: :strengths,
      label: "Sustainable resource use:",
      position: 9
    },
    economic_sustainability: {
      type: :strengths,
      label: "Economic sustainability:",
      position: 10
    },
    supporting_employees: {
      type: :strengths,
      label: "Supporting employees:",
      position: 11
    },
    internal_leadership: {
      type: :strengths,
      label: "Internal leadership & management:",
      position: 12
    },
    industry_sector: {
      type: :strengths,
      label: "Industry/sector leadership:",
      position: 13
    },
    verdict: {
      type: :verdict,
      label: "Overall verdict:",
      position: 14
    }
  }

  DEVELOPMENT_2017 = {
    product_service_contribution: {
      type: :rag,
      label: "Product/service contribution:",
      position: 0
    },
    commercial_success: {
      type: :rag,
      label: "Commercial success:",
      position: 1
    },
    environment: {
      type: :non_rag,
      label: "Environmental dimension:",
      position: 2
    },
    social: {
      type: :non_rag,
      label: "Social dimension:",
      position: 3
    },
    economic: {
      type: :non_rag,
      label: "Economic dimension:",
      position: 4
    },
    leadership_management: {
      type: :non_rag,
      label: "Leadership & management:",
      position: 5
    },
    corporate_social_responsibility: {
      type: :rag,
      label: "Corporate social responsibility (section D):",
      position: 6
    },
    environment_protection: {
      type: :strengths,
      label: "Environmental protection and management:",
      position: 7
    },
    benefiting_the_wilder_community: {
      type: :strengths,
      label: "Benefiting the wider community:",
      position: 8
    },
    sustainable_resource: {
      type: :strengths,
      label: "Sustainable resource use:",
      position: 9
    },
    economic_sustainability: {
      type: :strengths,
      label: "Economic sustainability:",
      position: 10
    },
    supporting_employees: {
      type: :strengths,
      label: "Supporting employees:",
      position: 11
    },
    internal_leadership: {
      type: :strengths,
      label: "Internal leadership & management:",
      position: 12
    },
    industry_sector: {
      type: :strengths,
      label: "Industry/sector leadership:",
      position: 13
    },
    verdict: {
      type: :verdict,
      label: "Overall verdict:",
      position: 14
    }
  }

  MOBILITY_2016 = {
    mobility_organisation_aiming_to_achieve: {
      type: :rag,
      label: "Questions B2 – B2.2: What is the organisation aiming to achieve with the programme? (10%)",
      position: 0
    },
    mobility_programme_provide_a_good: {
      type: :rag,
      label: "Questions B3 – B3.2: How does the programme provide a good return on investment? (15%)",
      position: 1
    },
    mobility_embedded_is_the_programme: {
      type: :rag,
      label: "Questions B4 – B4.2: How embedded is the programme, and how will it help the organisation grow? (15%)",
      position: 2
    },
    mobility_programme_benefit: {
      type: :rag,
      label: "Questions B5 – B5.1: How does the programme benefit people? (20%)",
      position: 3
    },
    mobility_programme_benefit_the_organisation: {
      type: :rag,
      label: "Questions B6 – B6.1: How does the programme benefit the organisation? (20%)",
      position: 4
    },
    mobility_organisation_approach: {
      type: :rag,
      label: "Question B7: What makes the organisation's approach exemplary? (20%)",
      position: 5
    },
    verdict: {
      type: :verdict,
      label: "Overall verdict:",
      position: 6
    }
  }

  MOBILITY_2017 = {
    mobility_organisation_aiming_to_achieve: {
      type: :rag,
      label: "Questions B2 – B2.2: What is the organisation aiming to achieve with the programme? (10%)",
      position: 0
    },
    mobility_programme_provide_a_good: {
      type: :rag,
      label: "Questions B3 – B3.2: How does the programme provide a good return on investment? (15%)",
      position: 1
    },
    mobility_embedded_is_the_programme: {
      type: :rag,
      label: "Questions B4 – B4.2: How embedded is the programme, and how will it help the organisation grow? (15%)",
      position: 2
    },
    mobility_programme_benefit: {
      type: :rag,
      label: "Questions B5 – B5.1: How does the programme benefit people? (20%)",
      position: 3
    },
    mobility_programme_benefit_the_organisation: {
      type: :rag,
      label: "Questions B6 – B6.1: How does the programme benefit the organisation? (20%)",
      position: 4
    },
    mobility_organisation_approach: {
      type: :rag,
      label: "Question B7: What makes the organisation's approach exemplary? (20%)",
      position: 5
    },
    corporate_social_responsibility: {
      type: :rag,
      label: "Corporate social responsibility (section D):",
      position: 6
    },
    verdict: {
      type: :verdict,
      label: "Overall verdict:",
      position: 7
    }
  }

  MODERATED_2016 = {
    verdict: {
      type: :verdict,
      label: "Overall verdict:"
    }
  }

  MODERATED_2017 = {
    verdict: {
      type: :verdict,
      label: "Overall verdict:"
    }
  }

  CASE_SUMMARY_METHODS_2016 = [
    :application_background_section_desc
  ]

  CASE_SUMMARY_METHODS_2017 = [
    :application_background_section_desc
  ]

  ALL_FORMS_2016 = [TRADE_2016, INNOVATION_2016, PROMOTION_2016, DEVELOPMENT_2016, MOBILITY_2016]
  ALL_FORMS_2017 = [TRADE_2017, INNOVATION_2017, PROMOTION_2017, DEVELOPMENT_2017, MOBILITY_2017]

  def self.rate(key)
    "#{key}_rate"
  end

  def self.desc(key)
    "#{key}_desc"
  end

  def self.meths_for_award_type(form_answer, moderated = false)
    award_type = form_answer.award_type
    award_year = form_answer.award_year

    if moderated
      assessment_types = [:verdict]
    else
      assessment_types = [:rag, :non_rag, :verdict]
    end
    const_get("#{award_type.upcase}_#{award_year.year}").map do |k, obj|
      methods = Array.new
      methods << Array(rate(k)) if ((!moderated && (obj[:type] != :non_rag)) || (moderated && obj[:type] == :verdict))
      methods << desc(k) if assessment_types.include?(obj[:type])
      methods
    end.flatten.map(&:to_sym)
  end

  def self.diff(form_answer, moderated = false)
    award_year = form_answer.award_year
    (all.map(&:to_sym) - meths_for_award_type(form_answer, moderated)).uniq - const_get("CASE_SUMMARY_METHODS_#{award_year.year}")
  end

  def self.all
    out = []

    AppraisalForm::SUPPORTED_YEARS.map do |year|
      const_get("ALL_FORMS_#{year}").each do |form|
        form.each do |k, obj|
          out << rate(k).to_sym if [:strengths, :rag, :non_rag, :verdict].include?(obj[:type])
          # strengths doesn't have description
          out << desc(k).to_sym if [:rag, :non_rag, :verdict].include?(obj[:type])
        end
      end

      out += const_get("CASE_SUMMARY_METHODS_#{year}")
    end

    out.uniq
  end

  def self.struct(form_answer, f = nil)
    meth = form_answer.respond_to?(:award_type_slug) ? :award_type_slug : :award_type
    year = form_answer.award_year.year

    # Assessor assignment
    moderated = (f && f.object && f.object.position == "moderated")

    list = if moderated
      const_get("MODERATED_#{year}")
    else
      const_get("#{form_answer.public_send(meth).upcase}_#{year}")
    end

    list.sort_by { |k, v| v[:position] }
  end

  def self.rates(form_answer, type)
    struct(form_answer).select { |_, v| v[:type] == type }
  end

  class << self
    def group_labels_by(year, type)
      %w(rag csr_rag strength verdict).map do |label_type|
        const_get("#{label_type.upcase}_OPTIONS_#{year}").detect do |el|
          el[1] == type
        end
      end.compact
         .map { |el| el[0] }
         .flatten
    end
  end
end
