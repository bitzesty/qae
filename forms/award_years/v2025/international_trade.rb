require "award_years/v2025/international_trade/international_trade_step1"
require "award_years/v2025/international_trade/international_trade_step2"
require "award_years/v2025/international_trade/international_trade_step3"
require "award_years/v2025/international_trade/international_trade_step4"
require "award_years/v2025/international_trade/international_trade_step5"
require "award_years/v2025/international_trade/international_trade_step6"

class AwardYears::V2025::QaeForms
  class << self
    def trade
      @trade ||= QaeFormBuilder.build "International Trade Award Application" do
        step "Consent & due diligence",
          "Consent & due diligence",
          &AwardYears::V2025::QaeForms.trade_step1

        step "Company information",
          "Company information",
          &AwardYears::V2025::QaeForms.trade_step2

        step "Your International Trade",
          "Your International Trade",
          &AwardYears::V2025::QaeForms.trade_step3

        step "Commercial Performance",
          "Commercial Performance",
          &AwardYears::V2025::QaeForms.trade_step4

        step "Environmental, Social & Corporate Governance (ESG)",
          "Environmental, Social & Corporate Governance (ESG)",
          &AwardYears::V2025::QaeForms.trade_step5

        step "Supplementary materials & confirmation",
          "Supplementary materials & confirmation",
          { id: :add_website_address_documents_step },
          &AwardYears::V2025::QaeForms.trade_step6
      end
    end
  end
end
