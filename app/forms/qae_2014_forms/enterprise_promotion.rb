require 'qae_2014_forms/enterprise_promotion/enterprise_promotion_step1'
require 'qae_2014_forms/enterprise_promotion/enterprise_promotion_step2'
require 'qae_2014_forms/enterprise_promotion/enterprise_promotion_step3'
require 'qae_2014_forms/enterprise_promotion/enterprise_promotion_step4'
require 'qae_2014_forms/enterprise_promotion/enterprise_promotion_step5'

class QAE2014Forms
  class << self
    def promotion
      @promotion ||= QAEFormBuilder.build 'Apply for the Enterprise Promotion Award' do
        step 'Nominee', 'Nominee', &QAE2014Forms.promotion_step1
        step 'Nominee background', 'Nominee background', &QAE2014Forms.promotion_step2
        step 'Recommendation', 'Recommendation', &QAE2014Forms.promotion_step3
        step 'Letters of support', 'Letters of support', &QAE2014Forms.promotion_step4
        step 'Authorisation and monitoring', 'Authorisation and monitoring', &QAE2014Forms.promotion_step5
      end
    end
  end
end
