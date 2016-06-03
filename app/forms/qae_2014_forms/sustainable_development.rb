require "qae_2014_forms/sustainable_development/sustainable_development_step1"
require "qae_2014_forms/sustainable_development/sustainable_development_step2"
require "qae_2014_forms/sustainable_development/sustainable_development_step3"
require "qae_2014_forms/sustainable_development/sustainable_development_step4"
require "qae_2014_forms/sustainable_development/sustainable_development_step5"
require "qae_2014_forms/sustainable_development/sustainable_development_step6"

class QAE2014Forms
  class << self
    def development
      @development ||= QAEFormBuilder.build "Sustainable Development Award Application" do
        step "Company Information",
             "Company Information",
             &QAE2014Forms.development_step1

        step "Your Sustainable Development",
             "Your Sustainable Development",
             &QAE2014Forms.development_step2

        step "Commercial Performance",
             "Commercial Performance",
             &QAE2014Forms.development_step3

        step "Declaration of Corporate Responsibility",
             "Declaration of Corporate Responsibility",
             &QAE2014Forms.development_step4

        step "Add Website Address/Documents",
             "Add Website Address/Documents",
             { id: :add_website_address_documents_step },
             &QAE2014Forms.development_step5

        step "Authorise & Submit",
             "Authorise & Submit",
             &QAE2014Forms.development_step6
      end
    end
  end
end
