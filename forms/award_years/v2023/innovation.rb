require "award_years/v2023/innovation/innovation_step1"
require "award_years/v2023/innovation/innovation_step2"
require "award_years/v2023/innovation/innovation_step3"
require "award_years/v2023/innovation/innovation_step4"
require "award_years/v2023/innovation/innovation_step5"
require "award_years/v2023/innovation/innovation_step6"

class AwardYears::V2023::QaeForms
  class << self
    def innovation
      @innovation ||= QaeFormBuilder.build "Innovation Award Application" do
        step "Company information",
          "Company information",
          &AwardYears::V2023::QaeForms.innovation_step1

        step "Your innovation",
          "Your innovation",
          &AwardYears::V2023::QaeForms.innovation_step2

        step "Commercial performance",
          "Commercial performance",
          &AwardYears::V2023::QaeForms.innovation_step3

        step "Corporate Social Responsibility (CSR)",
          "Corporate Social Responsibility (CSR)",
          &AwardYears::V2023::QaeForms.innovation_step4

        step "Supplementary materials",
          "Supplementary materials",
          { id: :add_website_address_documents_step },
          &AwardYears::V2023::QaeForms.innovation_step5

        step "Authorise and submit",
          "Authorise and submit",
          &AwardYears::V2023::QaeForms.innovation_step6
      end
    end
  end
end
