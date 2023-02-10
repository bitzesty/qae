require "award_years/v2024/innovation/innovation_step1"
require "award_years/v2024/innovation/innovation_step2"
require "award_years/v2024/innovation/innovation_step3"
require "award_years/v2024/innovation/innovation_step4"
require "award_years/v2024/innovation/innovation_step5"
require "award_years/v2024/innovation/innovation_step6"

class AwardYears::V2024::QAEForms
  class << self
    def innovation
      @innovation ||= QAEFormBuilder.build "Innovation Award Application" do
        step "Consent & due diligence",
             "Consent & due diligence",
             &AwardYears::V2024::QAEForms.innovation_step1

        step "Company information",
             "Company information",
             &AwardYears::V2024::QAEForms.innovation_step2

        step "Your innovation",
             "Your innovation",
             &AwardYears::V2024::QAEForms.innovation_step3

        step "Commercial performance",
             "Commercial performance",
             &AwardYears::V2024::QAEForms.innovation_step4

        step "Corporate Social Responsibility (CSR)",
             "Corporate Social Responsibility (CSR)",
             { id: :add_website_address_documents_step },
             &AwardYears::V2024::QAEForms.innovation_step5

        step "Supplementary materials",
             "Supplementary materials",
             { id: :add_website_address_documents_step },
             &AwardYears::V2024::QAEForms.innovation_step6
      end
    end
  end
end
