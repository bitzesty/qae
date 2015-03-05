class Assessment::AppraisalForm
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

  ENTERPRISE = {
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
    }
  }

  def self.all
    TRADE.keys + INNOVATION.keys + ENTERPRISE.keys
  end
end
