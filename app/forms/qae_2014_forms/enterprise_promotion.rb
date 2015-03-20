require "qae_2014_forms/enterprise_promotion/enterprise_promotion_step1"
require "qae_2014_forms/enterprise_promotion/enterprise_promotion_step2"
require "qae_2014_forms/enterprise_promotion/enterprise_promotion_step3"
require "qae_2014_forms/enterprise_promotion/enterprise_promotion_step4"
require "qae_2014_forms/enterprise_promotion/enterprise_promotion_step5"
require "qae_2014_forms/enterprise_promotion/enterprise_promotion_step6"

class QAE2014Forms
  class << self
    def promotion
      @promotion ||= QAEFormBuilder.build "Enterprise Promotion Award Nomination" do
        step "Nominee",
             "Nominee",
             &QAE2014Forms.promotion_step1

        step "Nominee Background",
             "Nominee Background",
             &QAE2014Forms.promotion_step2

        step "Recommendation",
             "Recommendation",
             &QAE2014Forms.promotion_step3

        step "Letters of Support",
             "Letters of Support",
             &QAE2014Forms.promotion_step4

        step "Add Links/Documents",
             "Add Links/Documents",
             &QAE2014Forms.promotion_step5

        step "Authorisation",
             "Authorisation",
             &QAE2014Forms.promotion_step6
      end
    end
  end
end
