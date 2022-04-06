require "award_years/v2023/innovation/innovation_step1"
require "award_years/v2023/innovation/innovation_step2"
require "award_years/v2023/innovation/innovation_step3"
require "award_years/v2023/innovation/innovation_step4"
require "award_years/v2023/innovation/innovation_step5"
require "award_years/v2023/innovation/innovation_step6"

class AwardYears::V2023::QAEForms
  class << self
    def innovation
      @innovation ||= QAEFormBuilder.build "Innovation Award Application" do
        step "Company Information",
             "Company Information",
             &AwardYears::V2023::QAEForms.innovation_step1

        step "Your Innovation",
             "Your Innovation",
             &AwardYears::V2023::QAEForms.innovation_step2

        step "Commercial Performance",
             "Commercial Performance",
             &AwardYears::V2023::QAEForms.innovation_step3

        step "Environmental Social Governance",
             "Environmental Social Governance",
             &AwardYears::V2023::QAEForms.innovation_step4

        step "Supplementary Materials",
             "Supplementary Materials",
             { id: :add_website_address_documents_step },
             &AwardYears::V2023::QAEForms.innovation_step5

        step "Authorise & Submit",
             "Authorise & Submit",
             &AwardYears::V2023::QAEForms.innovation_step6
      end
    end
  end
end
