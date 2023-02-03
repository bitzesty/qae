require "award_years/v2024/sustainable_development/sustainable_development_step1"
require "award_years/v2024/sustainable_development/sustainable_development_step2"
require "award_years/v2024/sustainable_development/sustainable_development_step3"
require "award_years/v2024/sustainable_development/sustainable_development_step4"
require "award_years/v2024/sustainable_development/sustainable_development_step5"
require "award_years/v2024/sustainable_development/sustainable_development_step6"

class AwardYears::V2024::QAEForms
  class << self
    def development
      @development ||= QAEFormBuilder.build "Sustainable Development Award Application" do
        step "Company information",
             "Company information",
             &AwardYears::V2024::QAEForms.development_step1

     #    step "Your Sustainable Development",
     #         "Your Sustainable Development",
     #         &AwardYears::V2024::QAEForms.development_step2

        step "Your Sustainable Development",
             "Your Sustainable Development",
             &AwardYears::V2024::QAEForms.development_step3

        step "Commercial Performance",
             "Commercial Performance",
             &AwardYears::V2024::QAEForms.development_step4

        step "Add Website Address/Documents",
             "Add Website Address/Documents",
             { id: :add_website_address_documents_step },
             &AwardYears::V2024::QAEForms.development_step5

        step "Authorise & Submit",
             "Authorise & Submit",
             &AwardYears::V2024::QAEForms.development_step6
      end
    end
  end
end
