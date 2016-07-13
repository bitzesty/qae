require "qae_2014_forms/social_mobility/social_mobility_step1"
require "qae_2014_forms/social_mobility/social_mobility_step2"
require "qae_2014_forms/social_mobility/social_mobility_step3"
require "qae_2014_forms/social_mobility/social_mobility_step4"
require "qae_2014_forms/social_mobility/social_mobility_step5"
require "qae_2014_forms/social_mobility/social_mobility_step6"

class QAE2014Forms
  class << self
    def mobility
      @mobility ||= QAEFormBuilder.build "Promoting Opportunity Award (through social mobility) Application" do
        step "Company Information",
             "Company Information",
             &QAE2014Forms.mobility_step1

        step "Your Social Mobility Programme(s)",
             "Your Social Mobility",
             &QAE2014Forms.mobility_step2

        step "Commercial Performance",
             "Commercial Performance",
             &QAE2014Forms.mobility_step3

        step "Declaration of Corporate Responsibility",
             "Declaration of Corporate Responsibility",
             &QAE2014Forms.mobility_step4

        step "Add Website Address/Documents",
             "Add Website Address/Documents",
             { id: :add_website_address_documents_step },
             &QAE2014Forms.mobility_step5

        step "Authorise & Submit",
             "Authorise & Submit",
             &QAE2014Forms.mobility_step6
      end
    end
  end
end
