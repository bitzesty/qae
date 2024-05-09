require "award_years/v2021/innovation/innovation_step1"
require "award_years/v2021/innovation/innovation_step2"
require "award_years/v2021/innovation/innovation_step3"
require "award_years/v2021/innovation/innovation_step4"
require "award_years/v2021/innovation/innovation_step5"
require "award_years/v2021/innovation/innovation_step6"

class AwardYears::V2021::QaeForms
  class << self
    def innovation
      @innovation ||= QaeFormBuilder.build "Innovation Award Application" do
        step "Company Information",
          "Company Information",
          &AwardYears::V2021::QaeForms.innovation_step1

        step "Your Innovation",
          "Your Innovation",
          &AwardYears::V2021::QaeForms.innovation_step2

        step "Commercial Performance",
          "Commercial Performance",
          &AwardYears::V2021::QaeForms.innovation_step3

        step "Declaration of Corporate Responsibility",
          "Declaration of Corporate Responsibility",
          &AwardYears::V2021::QaeForms.innovation_step4

        step "Add Website Address/Documents",
          "Add Website Address/Documents",
          { id: :add_website_address_documents_step },
          &AwardYears::V2021::QaeForms.innovation_step5

        step "Authorise & Submit",
          "Authorise & Submit",
          &AwardYears::V2021::QaeForms.innovation_step6
      end
    end
  end
end
