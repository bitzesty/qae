class AppraisalForm
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
      label: "Overseas Earnings Growth:"

    },
    commercial_success: {
      type: :rag,
      label: "Commercial Success:"
    },
    strategy: {
      type: :rag,
      label: "Strategy:"
    },
    verdict: {
      type: :verdict,
      label: "Overall Verdict:"
    }
  }

  INNOVATION = {
    level_of_innovation: {
      type: :rag,
      label: "Level of Innovation:"
    },
    extent_of_value_added: {
      type: :rag,
      label: "Extent of Value Added:"
    },
    impact_of_innovation: {
      type: :rag,
      label: "Impact of Innovation:"
    },
    verdict: {
      type: :verdict,
      label: "Overall Verdict:"
    }
  }

  PROMOTION = {
    nature_of_activities: {
      type: :rag,
      label: "Nature (breadth) of activities:"
    },
    impact_achievement: {
      type: :rag,
      label: "Impact/Achievement:"
    },
    level_of_support: {
      type: :rag,
      label: "Level of Support:"
    },
    verdict: {
      type: :verdict,
      label: "Overall Verdict:"
    }
  }

  DEVELOPMENT = {
    product_service_contribution: {
      type: :rag,
      label: "Product/Service Contribution:"
    },
    commercial_success: {
      type: :rag,
      label: "Commercial Success:"
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
      label: "Leadership & Management:"
    },
    environment_protection: {
      type: :strengths,
      label: "Environment Protection and Management:"
    },
    benefiting_the_wilder_community: {
      type: :strengths,
      label: "Benefiting the Wider Community:"
    },
    sustainable_resource: {
      type: :strengths,
      label: "Sustainable Resource Use: Select Key Strengths and Focuses:"
    },
    economic_sustainability: {
      type: :strengths,
      label: "Economic Sustainability:"
    },
    supporting_employees: {
      type: :strengths,
      label: "Supporting Employees:"
    },
    internal_leadership: {
      type: :strengths,
      label: "Internal Leadership & Management:"
    },
    industry_sector: {
      type: :strengths,
      label: "Industry/Sector Leadership:"
    },
    verdict: {
      type: :verdict,
      label: "Overall Verdict:"
    }
  }

  def self.rate(key)
    "#{key}_rate"
  end

  def self.desc(key)
    "#{key}_desc"
  end

  def self.meths_for_award_type(award_type)
    const_get(award_type.upcase).map do |k, _|
      [rate(k), desc(k)]
    end.flatten.map(&:to_sym)
  end

  def self.diff(award_type)
    (all.map(&:to_sym) - meths_for_award_type(award_type)).uniq
  end

  def self.all
    keys = TRADE.keys + INNOVATION.keys + PROMOTION.keys + DEVELOPMENT.keys
    out = keys.map { |k| rate(k).to_sym }
    out += keys.map { |k| desc(k).to_sym }
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
