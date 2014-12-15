require 'qae_2014_forms/sustainable_development/sustainable_development_step1'
require 'qae_2014_forms/sustainable_development/sustainable_development_step2'
require 'qae_2014_forms/sustainable_development/sustainable_development_step3'
require 'qae_2014_forms/sustainable_development/sustainable_development_step4'
require 'qae_2014_forms/sustainable_development/sustainable_development_step5'

class QAE2014Forms
  class << self
    def development
      @development ||= QAEFormBuilder.build 'Apply for the Sustainable Development Award' do

        step 'Company Information', 'Company Info', &QAE2014Forms.development_step1

        step 'Commercial Performance', 'Commercial Performance', &QAE2014Forms.development_step2

        step 'Description of Goods or Services', 'Description', &QAE2014Forms.development_step3

        step 'Declaration of Corporate Responsibility', 'Corporate Responsibility', &QAE2014Forms.development_step4

        step 'Authorisation/Monitoring', 'Authorisation', &QAE2014Forms.development_step5

      end
    end
  end
end
