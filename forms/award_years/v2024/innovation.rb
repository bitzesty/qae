require "award_years/v2024/innovation/innovation_step1"
require "award_years/v2024/innovation/innovation_step2"
require "award_years/v2024/innovation/innovation_step3"
require "award_years/v2024/innovation/innovation_step4"
require "award_years/v2024/innovation/innovation_step5"
require "award_years/v2024/innovation/innovation_step6"

class AwardYears::V2024::QaeForms
  class << self
    def innovation
      @innovation ||= QaeFormBuilder.build "Innovation Award Application" do
        step "Consent & due diligence",
             "Consent & due diligence",
             &AwardYears::V2024::QaeForms.innovation_step1

        step "Company information",
             "Company information",
             &AwardYears::V2024::QaeForms.innovation_step2

        step "Your innovation",
             "Your innovation",
             &AwardYears::V2024::QaeForms.innovation_step3

        step "Commercial performance",
             "Commercial performance",
             &AwardYears::V2024::QaeForms.innovation_step4

        step "Environmental, social & corporate governance (ESG)",
             "Environmental, social & corporate governance (ESG)",
             &AwardYears::V2024::QaeForms.innovation_step5

        step "Supplementary materials & confirmation",
             "Supplementary materials & confirmation",
             { id: :add_website_address_documents_step },
             &AwardYears::V2024::QaeForms.innovation_step6
      end
    end
  end
end
