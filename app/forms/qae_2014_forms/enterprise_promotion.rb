require 'qae_2014_forms/enterprise_promotion/enterprise_promotion_step1'
#require 'qae_2014_forms/innovation/innovation_step2'
#require 'qae_2014_forms/innovation/innovation_step3'
#require 'qae_2014_forms/innovation/innovation_step4'
#require 'qae_2014_forms/innovation/innovation_step5'
#require 'qae_2014_forms/innovation/innovation_step6'

class QAE2014Forms
  class << self
    def promotion
      @promotion ||= QAEFormBuilder.build 'Apply for the Enterprise Promotion Award' do

        step 'Nominee', 'Nominee', &QAE2014Forms.promotion_step1

        #step 'Description of Goods or Services', "Description", &QAE2014Forms.innovation_step2

        #step 'Commercial Performance', "Commercial Performance", &QAE2014Forms.innovation_step3

        #step 'Declaration of Corporate Responsibility', "Corporate Responsibility", &QAE2014Forms.innovation_step4

        #step 'Add Links/Documents', "Add Links/Documents", &QAE2014Forms.innovation_step5

        #step 'Authorisation/Monitoring', "Authorisation", &QAE2014Forms.innovation_step6

      end
    end
  end
end
