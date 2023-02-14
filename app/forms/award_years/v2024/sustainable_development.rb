require "award_years/v2024/sustainable_development/sustainable_development_step1"
require "award_years/v2024/sustainable_development/sustainable_development_step2"
require "award_years/v2024/sustainable_development/sustainable_development_step3"
require "award_years/v2024/sustainable_development/sustainable_development_step4"
require "award_years/v2024/sustainable_development/sustainable_development_step5"

class AwardYears::V2024::QAEForms
  class << self
    def development
      @development ||= QAEFormBuilder.build "Sustainable Development Award Application" do
        step "Consent & Due Diligence",
             "Consent & Due Diligence",
             &AwardYears::V2024::QAEForms.development_step1

        step "Company Information",
             "Company Information",
             &AwardYears::V2024::QAEForms.development_step2

        step "Your Sustainable Development",
             "Your Sustainable Development",
             &AwardYears::V2024::QAEForms.development_step3

        step "Commercial Performance",
             "Commercial Performance",
             &AwardYears::V2024::QAEForms.development_step4

        step "Supplementary Materials & Confirmation",
             "Supplementary Materials & Confirmation",
             { id: :add_website_address_documents_step },
             &AwardYears::V2024::QAEForms.development_step5
      end
    end
  end
end
