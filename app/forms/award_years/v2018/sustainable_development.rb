require "award_years/v2018/sustainable_development/sustainable_development_step1"
require "award_years/v2018/sustainable_development/sustainable_development_step2"
require "award_years/v2018/sustainable_development/sustainable_development_step3"
require "award_years/v2018/sustainable_development/sustainable_development_step4"
require "award_years/v2018/sustainable_development/sustainable_development_step5"
require "award_years/v2018/sustainable_development/sustainable_development_step6"

class AwardYears::V2018::QaeForms
  class << self
    def development
      @development ||= QaeFormBuilder.build "Sustainable Development Award Application" do
        step "Company Information",
             "Company Information",
             &AwardYears::V2018::QaeForms.development_step1

        step "Your Sustainable Development",
             "Your Sustainable Development",
             &AwardYears::V2018::QaeForms.development_step2

        step "Commercial Performance",
             "Commercial Performance",
             &AwardYears::V2018::QaeForms.development_step3

        step "Declaration of Corporate Responsibility",
             "Declaration of Corporate Responsibility",
             &AwardYears::V2018::QaeForms.development_step4

        step "Add Website Address/Documents",
             "Add Website Address/Documents",
             { id: :add_website_address_documents_step },
             &AwardYears::V2018::QaeForms.development_step5

        step "Authorise & Submit",
             "Authorise & Submit",
             &AwardYears::V2018::QaeForms.development_step6
      end
    end
  end
end
