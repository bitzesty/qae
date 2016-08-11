class AppraisalForm
  RAG_OPTIONS = [
    ["Weak (0-15)", "negative"],
    ["Satisfactory (16-31)", "average"],
    ["Exceptional (32-50)", "positive"]
  ]

  STRENGTH_OPTIONS = [
    ["Insufficient Information Supplied", "neutral"],
    ["Priority Focus for Development", "negative"],
    ["Positive - Scope for Ongoing Development", "average"],
    ["Key Strength", "positive"]
  ]

  VERDICT_OPTIONS = [
    ["Not Recommended", "negative"],
    ["Reserved", "average"],
    ["Recommended", "positive"]
  ]

  def self.rag_options_for(object, section)
    options = RAG_OPTIONS

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
    options = STRENGTH_OPTIONS

    option = options.detect do |opt|
      opt[1] == object.public_send(section.rate)
    end || ["Select Key Strengths and Focuses", "blank"]

    OpenStruct.new(
      options: options,
      option: option
    )
  end

  def self.verdict_options_for(object, section)
    options = VERDICT_OPTIONS

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

  TRADE = {
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
    strategy: {
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

  INNOVATION = {
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
    strategy: {
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

  PROMOTION = {
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
    strategy: {
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

  DEVELOPMENT = {
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
    strategy: {
      type: :rag,
      label: "Corporate social responsibility (section D):",
      position: 7
    },
    environment_protection: {
      type: :strengths,
      label: "Environmental protection and management:",
      position: 8
    },
    benefiting_the_wilder_community: {
      type: :strengths,
      label: "Benefiting the wider community:",
      position: 9
    },
    sustainable_resource: {
      type: :strengths,
      label: "Sustainable resource use:",
      position: 10
    },
    economic_sustainability: {
      type: :strengths,
      label: "Economic sustainability:",
      position: 11
    },
    supporting_employees: {
      type: :strengths,
      label: "Supporting employees:",
      position: 12
    },
    internal_leadership: {
      type: :strengths,
      label: "Internal leadership & management:",
      position: 13
    },
    industry_sector: {
      type: :strengths,
      label: "Industry/sector leadership:",
      position: 14
    },
    verdict: {
      type: :verdict,
      label: "Overall verdict:",
      position: 15
    }
  }

  MOBILITY = {
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
    strategy: {
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

  MODERATED = {
    verdict: {
      type: :verdict,
      label: "Overall verdict:"
    }
  }

  CASE_SUMMARY_METHODS = [
    :application_background_section_desc
  ]

  ALL_FORMS = [TRADE, INNOVATION, PROMOTION, DEVELOPMENT, MOBILITY]

  def self.rate(key)
    "#{key}_rate"
  end

  def self.desc(key)
    "#{key}_desc"
  end

  def self.meths_for_award_type(award_type, moderated = false)
    if moderated
      assessment_types = [:verdict]
    else
      assessment_types = [:rag, :non_rag, :verdict]
    end
    const_get(award_type.upcase).map do |k, obj|
      methods = Array.new
      methods << Array(rate(k)) if ((!moderated && (obj[:type] != :non_rag)) || (moderated && obj[:type] == :verdict))
      methods << desc(k) if assessment_types.include?(obj[:type])
      methods
    end.flatten.map(&:to_sym)
  end

  def self.diff(award_type, moderated = false)
    (all.map(&:to_sym) - meths_for_award_type(award_type, moderated)).uniq - CASE_SUMMARY_METHODS
  end

  def self.all
    out = []

    ALL_FORMS.each do |form|
      form.each do |k, obj|
        out << rate(k).to_sym if [:strengths, :rag, :non_rag, :verdict].include?(obj[:type])
        # strengths doesn't have description
        out << desc(k).to_sym if [:rag, :non_rag, :verdict].include?(obj[:type])
      end
    end

    out += CASE_SUMMARY_METHODS
    out
  end

  def self.struct(form_answer, f = nil)
    meth = form_answer.respond_to?(:award_type_slug) ? :award_type_slug : :award_type

    # Assessor assignment
    moderated = (f && f.object && f.object.position == "moderated")

    list = if moderated
      MODERATED
    else
      const_get(form_answer.public_send(meth).upcase)
    end

    list.sort_by { |k, v| v[:position] }
  end

  def self.rates(form_answer, type)
    struct(form_answer).select { |_, v| v[:type] == type }
  end

  class << self
    def group_labels_by(type)
      %w(rag strength verdict).map do |label_type|
        const_get("#{label_type.upcase}_OPTIONS").detect do |el|
          el[1] == type
        end
      end.compact
         .map { |el| el[0] }
         .flatten
    end
  end
end
