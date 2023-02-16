require "award_years/v2024/international_trade/international_trade_step1"
require "award_years/v2024/international_trade/international_trade_step2"
require "award_years/v2024/international_trade/international_trade_step3"
require "award_years/v2024/international_trade/international_trade_step4"
require "award_years/v2024/international_trade/international_trade_step5"
require "award_years/v2024/international_trade/international_trade_step6"

class AwardYears::V2024::QAEForms
  class << self
    def trade
      @trade ||= QAEFormBuilder.build "International Trade Award Application" do
        step "Company information",
             "Company information",
             &AwardYears::V2024::QAEForms.trade_step1

        step "Your International Trade",
             "Your International Trade",
             &AwardYears::V2024::QAEForms.trade_step2

        step "Commercial Performance",
             "Commercial Performance",
             &AwardYears::V2024::QAEForms.trade_step3

        step "Corporate Social Responsibility (CSR)",
             "Corporate Social Responsibility (CSR)",
             &AwardYears::V2024::QAEForms.trade_step4

        step "Add Website Address/Documents",
             "Add Website Address/Documents",
             { id: :add_website_address_documents_step },
             &AwardYears::V2024::QAEForms.trade_step5

        step "Authorise & Submit",
             "Authorise & Submit",
             &AwardYears::V2024::QAEForms.trade_step6
      end
    end
  end
end
