require "award_years/v2023/sustainable_development/sustainable_development_step1"
require "award_years/v2023/sustainable_development/sustainable_development_step2"
require "award_years/v2023/sustainable_development/sustainable_development_step3"
require "award_years/v2023/sustainable_development/sustainable_development_step4"
require "award_years/v2023/sustainable_development/sustainable_development_step5"

class AwardYears::V2023::QAEForms
  class << self
    def development
      @development ||= QAEFormBuilder.build "Sustainable Development Award Application" do
        step "Company information",
             "Company information",
             &AwardYears::V2023::QAEForms.development_step1

        step "Your Sustainable Development",
             "Your Sustainable Development",
             &AwardYears::V2023::QAEForms.development_step2

        step "Commercial Performance",
             "Commercial Performance",
             &AwardYears::V2023::QAEForms.development_step3

        step "Add Website Address/Documents",
             "Add Website Address/Documents",
             { id: :add_website_address_documents_step },
             &AwardYears::V2023::QAEForms.development_step4

        step "Authorise & Submit",
             "Authorise & Submit",
             &AwardYears::V2023::QAEForms.development_step5
      end
    end
  end
end
