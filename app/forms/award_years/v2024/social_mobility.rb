require "award_years/v2024/social_mobility/social_mobility_step1"
require "award_years/v2024/social_mobility/social_mobility_step2"
require "award_years/v2024/social_mobility/social_mobility_step3"
require "award_years/v2024/social_mobility/social_mobility_step4"
require "award_years/v2024/social_mobility/social_mobility_step5"
require "award_years/v2024/social_mobility/social_mobility_step6"

class AwardYears::V2024::QAEForms
  class << self
    def mobility
      @mobility ||= QAEFormBuilder.build "Promoting Opportunity Award (through social mobility) Application" do
        step "Company information",
             "Company information",
             &AwardYears::V2024::QAEForms.mobility_step1

        step "Your Social Mobility Programme(s)",
             "Your Social Mobility Programme(s)",
             &AwardYears::V2024::QAEForms.mobility_step2

        step "Commercial Performance",
             "Commercial Performance",
             &AwardYears::V2024::QAEForms.mobility_step3

        step "Corporate Social Responsibility (CSR)",
             "Corporate Social Responsibility (CSR)",
             &AwardYears::V2024::QAEForms.mobility_step4

        step "Add Website Address/Documents",
             "Add Website Address/Documents",
             { id: :add_website_address_documents_step },
             &AwardYears::V2024::QAEForms.mobility_step5

        step "Authorise & Submit",
             "Authorise & Submit",
             &AwardYears::V2024::QAEForms.mobility_step6
      end
    end
  end
end
