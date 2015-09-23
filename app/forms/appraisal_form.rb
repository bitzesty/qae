class AppraisalForm
  def self.rag_options_for(object, section)
    options = [%w(Red negative), %w(Amber average), %w(Green positive)]
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

  def self.strenght_options_for(object, section)
    options = [
      ["Insufficient Information Supplied", "neutral"],
      ["Priority Focus for Development", "negative"],
      ["Positive - Scope for Ongoing Development", "average"],
      ["Key Strength", "positive"]
    ]
    option = options.detect do |opt|
      opt[1] == object.public_send(section.rate)
    end || ["Select Key Strengths and Focuses", "blank"]

    OpenStruct.new(
      options: options,
      option: option
    )
  end

  def self.verdict_options_for(object, section)
    options = [
      ["Not Recommended", "negative"],
      ["Reserved", "average"],
      ["Recommended", "positive"]
    ]

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

  MODERATED = {
    verdict: {
      type: :verdict,
      label: "Overall verdict:"
    }
  }

  CASE_SUMMARY_METHODS = [
    :application_background_section_desc
  ]

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
    forms = [TRADE, INNOVATION, PROMOTION, DEVELOPMENT]
    out = []
    forms.each do |form|
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
end
