require "award_years/v2018/enterprise_promotion/enterprise_promotion_step1"
require "award_years/v2018/enterprise_promotion/enterprise_promotion_step2"
require "award_years/v2018/enterprise_promotion/enterprise_promotion_step3"
require "award_years/v2018/enterprise_promotion/enterprise_promotion_step4"
require "award_years/v2018/enterprise_promotion/enterprise_promotion_step5"
require "award_years/v2018/enterprise_promotion/enterprise_promotion_step6"

class AwardYears::V2018::QaeForms
  class << self
    def promotion
      @promotion ||= QaeFormBuilder.build "Enterprise Promotion Award Nomination" do
        step "Nominee",
          "Nominee",
          &AwardYears::V2018::QaeForms.promotion_step1

        step "Nominee Background",
          "Nominee Background",
          { id: :position_details_step },
          &AwardYears::V2018::QaeForms.promotion_step2

        step "Recommendation",
          "Recommendation",
          &AwardYears::V2018::QaeForms.promotion_step3

        step "Letters of Support",
          "Letters of Support",
          { id: :letters_of_support_step },
          &AwardYears::V2018::QaeForms.promotion_step4

        step "Add Website Address/Documents",
          "Add Website Address/Documents",
          { id: :add_website_address_documents_step },
          &AwardYears::V2018::QaeForms.promotion_step5

        step "Authorise & Submit",
          "Authorise & Submit",
          &AwardYears::V2018::QaeForms.promotion_step6
      end
    end
  end
end
