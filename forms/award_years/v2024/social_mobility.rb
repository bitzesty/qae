require "award_years/v2024/social_mobility/social_mobility_step1"
require "award_years/v2024/social_mobility/social_mobility_step2"
require "award_years/v2024/social_mobility/social_mobility_step3"
require "award_years/v2024/social_mobility/social_mobility_step4"
require "award_years/v2024/social_mobility/social_mobility_step5"
require "award_years/v2024/social_mobility/social_mobility_step6"

class AwardYears::V2024::QaeForms
  class << self
    def mobility
      @mobility ||= QaeFormBuilder.build "Promoting Opportunity Award (through social mobility) Application" do
        step "Consent & due diligence",
             "Consent & due diligence",
             &AwardYears::V2024::QaeForms.mobility_step1

        step "Company information",
             "Company information",
             &AwardYears::V2024::QaeForms.mobility_step2

        step "Your Social Mobility Initiative",
             "Your Social Mobility Initiative",
             &AwardYears::V2024::QaeForms.mobility_step3

        step "Commercial Performance",
             "Commercial Performance",
             &AwardYears::V2024::QaeForms.mobility_step4

        step "Environmental, Social & Corporate Governance (ESG)",
             "Environmental, Social & Corporate Governance (ESG)",
             &AwardYears::V2024::QaeForms.mobility_step5

        step "Supplementary materials & confirmation",
             "Supplementary materials & confirmation",
             { id: :add_website_address_documents_step },
             &AwardYears::V2024::QaeForms.mobility_step6
      end
    end
  end
end
