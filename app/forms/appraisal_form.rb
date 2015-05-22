class AppraisalForm
  def self.rag_options_for(object, section)
    options = [%w(Red negative), %w(Amber average), %w(Green positive)]
    option = options.detect do |opt|
      opt[1] == object.public_send(section.rate)
    end || ["Select RAG", "neutral"]

    OpenStruct.new(
      options: options,
      option: option
    )
  end

  def self.strenght_options_for(object, section)
    options = [
      ["Insufficient Information Supplied", "blank"],
      ["Priority Focus for Development", "negative"],
      ["Positive - Scop for Ongoing Development", "average"],
      ["Key Strength", "positive"]
    ]
    option = options.detect do |opt|
      opt[1] == object.public_send(section.rate)
    end || ["Select Key Strengths and Focuses", "neutral"]

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
    end || ["Select verdict", "neutral"]

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

  STRENGTHS_ALLOWED_VALUES = [
    "blank",
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
      type: :rag,
      label: "Environment:"
    },
    social: {
      type: :rag,
      label: "Social:"
    },
    economic: {
      type: :rag,
      label: "Economic:"
    },
    leadership_management: {
      type: :rag,
      label: "Leadership & management:"
    },
    environment_protection: {
      type: :strengths,
      label: "Environment protection and management:"
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

  CASE_SUMMARY_METHODS = [
    :application_background_section_desc
  ]

  def self.rate(key)
    "#{key}_rate"
  end

  def self.desc(key)
    "#{key}_desc"
  end

  def self.meths_for_award_type(award_type)
    const_get(award_type.upcase).map do |k, obj|
      methods = Array(rate(k))
      methods << desc(k) if [:rag, :verdict].include?(obj[:type])
      methods
    end.flatten.map(&:to_sym)
  end

  def self.diff(award_type)
    (all.map(&:to_sym) - meths_for_award_type(award_type)).uniq - CASE_SUMMARY_METHODS
  end

  def self.all
    forms = [TRADE, INNOVATION, PROMOTION, DEVELOPMENT]
    out = []
    forms.each do |form|
      form.each do |k, obj|
        out << rate(k).to_sym if [:strengths, :rag, :verdict].include?(obj[:type])
        # strenghts doesn't have description
        out << desc(k).to_sym if [:rag, :verdict].include?(obj[:type])
      end
    end

    out += CASE_SUMMARY_METHODS
    out
  end

  def self.struct(form_answer)
    meth = form_answer.respond_to?(:award_type_slug) ? :award_type_slug : :award_type
    const_get(form_answer.public_send(meth).upcase)
  end

  def self.rates(form_answer, type)
    struct(form_answer).select { |_, v| v[:type] == type }
  end
end
