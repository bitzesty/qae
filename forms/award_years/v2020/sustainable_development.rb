require "award_years/v2020/sustainable_development/sustainable_development_step1"
require "award_years/v2020/sustainable_development/sustainable_development_step2"
require "award_years/v2020/sustainable_development/sustainable_development_step3"
require "award_years/v2020/sustainable_development/sustainable_development_step4"
require "award_years/v2020/sustainable_development/sustainable_development_step5"

class AwardYears::V2020::QaeForms
  class << self
    def development
      @development ||= QaeFormBuilder.build "Sustainable Development Award Application" do
        step "Company Information",
          "Company Information",
          &AwardYears::V2020::QaeForms.development_step1

        step "Your Sustainable Development",
          "Your Sustainable Development",
          &AwardYears::V2020::QaeForms.development_step2

        step "Commercial Performance",
          "Commercial Performance",
          &AwardYears::V2020::QaeForms.development_step3

        step "Add Website Address/Documents",
          "Add Website Address/Documents",
          { id: :add_website_address_documents_step },
          &AwardYears::V2020::QaeForms.development_step4

        step "Authorise & Submit",
          "Authorise & Submit",
          &AwardYears::V2020::QaeForms.development_step5
      end
    end
  end
end
