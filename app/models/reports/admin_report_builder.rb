require "csv"

class Reports::AdminReportBuilder
  MAPPING = [
    {
      label: "URN",
      method: :urn
    },
    {
      label: "ApplicantName"
    },
    {
      label: "RegisteredUserId",
      method: :user_id
    },
    {
      label: "RegisteredUserTitle",
      method: :title
    },
    {
      label: "RegisteredUserFirstname",
      method: :first_name
    },
    {
      label: "RegisteredUserSurname",
      method: :last_name
    },
    {
      label: "RegisteredUserEmail",
      method: :head_email
    },
    {
      label: "RegisteredUserCompany",
      method: :company_name
    },
    {
      label: "RegisteredUserAddressLine1",
      method: :address_line1
    },
    {
      label: "RegisteredUserAddressLine2",
      method: :address_line2
    },
    {
      label: "RegisteredUserAddressLine3",
      method: :address_line3
    },
    {
      label: "RegisteredUserPostcode",
      method: :postcode
    },
    {
      label: "RegisteredUserTelephone1",
      method: :telephone1
    },
    {
      label: "RegisteredUserTelephone2",
      method: :telephone2
    },
    {
      label: "RegisteredUserMobile"
    },
    {
      label: "FormType",
      method: :award_type
    },
    {
      label: "PercentageComplete",
      method: :percentage_complete
    },
    {
      label: "Section 1",
      method: :section1
    },
    {
      label: "Section 2",
      method: :section2
    },
    {
      label: "Section 3",
      method: :section3
    },
    {
      label: "Section 4",
      method: :section4
    },
    {
      label: "Section 5",
      method: :section5
    },
    {
      label: "Section 6",
      method: :section6
    },
    {
      label: "Created",
      method: :created_at
    },
    {
      label: "UserCreationDate",
      method: :user_creation_date
    },
    {
      label: "BusinessSector",
      method: :business_sector
    },
    {
      label: "BusinessSectorOther",
      method: :business_sector_other
    },
    {
      label: "Region"
    },
    {
      label: "Employees"
    },
    {
      label: "QAOPermission",
      method: :qao_permission
    },
    {
      label: "HowDidYouHearAboutQA",
      method: :qae_info_source
    },
    {
      label: "HowDidYouHearAboutQAOther",
      method: :qae_info_source_other
    }
  ]

  def initialize
    @scope = ::FormAnswer.all.includes(:user)
  end

  def build
    csv_string = CSV.generate do |csv|
      csv << headers
      @scope.each do |form_answer|
        form_answer = Reports::FormAnswer.new(form_answer)
        csv << MAPPING.map do |m|
          form_answer.call_method(m[:method])
        end
      end
    end

    csv_string
  end

  private

  def headers
    MAPPING.map { |m| m[:label] }
  end
end
