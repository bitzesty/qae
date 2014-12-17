require 'qae_2014_forms/innovation/innovation_step1'
require 'qae_2014_forms/innovation/innovation_step2'
require 'qae_2014_forms/innovation/innovation_step3'
require 'qae_2014_forms/innovation/innovation_step4'
require 'qae_2014_forms/innovation/innovation_step5'

class QAE2014Forms
  class << self
    def innovation
      @innovation ||= QAEFormBuilder.build 'Apply for the Innovation Award' do

        step 'Company Information', "Company Info", &QAE2014Forms.innovation_step1

        step 'Description of Goods or Services', "Description", &QAE2014Forms.innovation_step2

        step 'Commercial Performance', "Commercial Performance", &QAE2014Forms.innovation_step3

        step 'Declaration of Corporate Responsibility', "Corporate Responsibility", &QAE2014Forms.innovation_step4

        step 'Authorisation/Monitoring', "Authorisation", &QAE2014Forms.innovation_step5

      end
    end
  end
end
