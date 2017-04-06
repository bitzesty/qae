require "qae_forms/enterprise_promotion/enterprise_promotion_step1"
require "qae_forms/enterprise_promotion/enterprise_promotion_step2"
require "qae_forms/enterprise_promotion/enterprise_promotion_step3"
require "qae_forms/enterprise_promotion/enterprise_promotion_step4"
require "qae_forms/enterprise_promotion/enterprise_promotion_step5"
require "qae_forms/enterprise_promotion/enterprise_promotion_step6"

class QAEForms
  class << self
    def promotion
      @promotion ||= QAEFormBuilder.build "Enterprise Promotion Award Nomination" do
        step "Nominee",
             "Nominee",
             &QAEForms.promotion_step1

        step "Nominee Background",
             "Nominee Background",
             { id: :position_details_step },
             &QAEForms.promotion_step2

        step "Recommendation",
             "Recommendation",
             &QAEForms.promotion_step3

        step "Letters of Support",
             "Letters of Support",
             { id: :letters_of_support_step },
             &QAEForms.promotion_step4

        step "Add Website Address/Documents",
             "Add Website Address/Documents",
             { id: :add_website_address_documents_step },
             &QAEForms.promotion_step5

        step "Authorise & Submit",
             "Authorise & Submit",
             &QAEForms.promotion_step6
      end
    end
  end
end
