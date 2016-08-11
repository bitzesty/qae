class AppraisalForm
  RAG_OPTIONS = [
    %w(Red negative),
    %w(Amber average),
    %w(Green positive)
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
      label: "Overseas earnings growth:"

    },
    commercial_success: {
      type: :rag,
      label: "Commercial success:"
    },
    strategy: {
      type: :rag,
      label: "Strategy:"
    },
    verdict: {
      type: :verdict,
      label: "Overall verdict:"
    }
  }

  INNOVATION = {
    level_of_innovation: {
      type: :rag,
      label: "Level of innovation:"
    },
    extent_of_value_added: {
      type: :rag,
      label: "Extent of value added:"
    },
    impact_of_innovation: {
      type: :rag,
      label: "Impact of innovation:"
    },
    verdict: {
      type: :verdict,
      label: "Overall verdict:"
    }
  }

  PROMOTION = {
    nature_of_activities: {
      type: :rag,
      label: "Nature (breadth) of activities:"
    },
    impact_achievement: {
      type: :rag,
      label: "Impact/achievement:"
    },
    level_of_support: {
      type: :rag,
      label: "Level of support:"
    },
    verdict: {
      type: :verdict,
      label: "Overall verdict:"
    }
  }

  DEVELOPMENT = {
    product_service_contribution: {
      type: :rag,
      label: "Product/service contribution:"
    },
    commercial_success: {
      type: :rag,
      label: "Commercial success:"
    },
    strategy: {
      type: :rag,
      label: "Strategy:"
    },
    environment: {
      type: :non_rag,
      label: "Environmental dimension:"
    },
    social: {
      type: :non_rag,
      label: "Social dimension:"
    },
    economic: {
      type: :non_rag,
      label: "Economic dimension:"
    },
    leadership_management: {
      type: :non_rag,
      label: "Leadership & management:"
    },
    environment_protection: {
      type: :strengths,
      label: "Environmental protection and management:"
    },
    benefiting_the_wilder_community: {
      type: :strengths,
      label: "Benefiting the wider community:"
    },
    sustainable_resource: {
      type: :strengths,
      label: "Sustainable resource use:"
    },
    economic_sustainability: {
      type: :strengths,
      label: "Economic sustainability:"
    },
    supporting_employees: {
      type: :strengths,
      label: "Supporting employees:"
    },
    internal_leadership: {
      type: :strengths,
      label: "Internal leadership & management:"
    },
    industry_sector: {
      type: :strengths,
      label: "Industry/sector leadership:"
    },
    verdict: {
      type: :verdict,
      label: "Overall verdict:"
    }
  }

  MOBILITY = {
    mobility_organisation_aiming_to_achieve: {
      type: :rag,
      label: "Questions B2 – B2.2: What is the organisation aiming to achieve with the programme? (10%)"
    },
    mobility_programme_provide_a_good: {
      type: :rag,
      label: "Questions B3 – B3.2: How does the programme provide a good return on investment? (15%)"
    },
    mobility_embedded_is_the_programme: {
      type: :rag,
      label: "Questions B4 – B4.2: How embedded is the programme, and how will it help the organisation grow? (15%)"
    },
    mobility_programme_benefit: {
      type: :rag,
      label: "Questions B5 – B5.1: How does the programme benefit people? (20%)"
    },
    mobility_programme_benefit_the_organisation: {
      type: :rag,
      label: "Questions B6 – B6.1: How does the programme benefit the organisation? (20%)"
    },
    mobility_organisation_approach: {
      type: :rag,
      label: "Question B7: What makes the organisation's approach exemplary? (20%)"
    },
    verdict: {
      type: :verdict,
      label: "Overall verdict:"
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

    if moderated
      MODERATED
    else
      const_get(form_answer.public_send(meth).upcase)
    end
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
