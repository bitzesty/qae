require 'qae_2014_forms/enterprise_promotion/enterprise_promotion_step1'
require 'qae_2014_forms/enterprise_promotion/enterprise_promotion_step2'

class QAE2014Forms
  class << self
    def promotion
      @promotion ||= QAEFormBuilder.build 'Apply for the Enterprise Promotion Award' do

        step 'Nominee', 'Nominee', &QAE2014Forms.promotion_step1
        step 'Nominee background', 'Nominee background', &QAE2014Forms.promotion_step2

      end
    end
  end
end
