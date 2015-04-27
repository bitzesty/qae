class Reports::RegisteredUsers
  include Reports::CSVHelper

  MAPPING = [
    {
      label: "URN",
      method: :urn
    },
    {
      label: "ApplicantName",
      method: :company_or_nominee_name
    },
    {
      label: "RegisteredUserId",
      method: :user_id
    },
    {
      label: "RegisteredUserTitle",
      method: :contact_title
    },
    {
      label: "RegisteredUserFirstname",
      method: :contact_first_name
    },
    {
      label: "RegisteredUserSurname",
      method: :contact_surname
    },
    {
      label: "RegisteredUserEmail",
      method: :contact_email
    },
    {
      label: "RegisteredUserCompany",
      method: :company_name
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
      label: "Region",
      method: :business_region
    },
    {
      label: "Employees",
      method: :employees
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

  def initialize(year)
    @year = year
  end

  def build
    rows = []

    scope = ::FormAnswer.select(:id).where(award_year_id: @year.id)
    scope.find_in_batches do |batch|
      form_answers = FormAnswer.where(id: batch.map(&:id))
                     .includes(:user,
                               :assessor_assignments,
                               :primary_assessor,
                               :secondary_assessor,
                               :form_answer_progress
                              )
      form_answers.each do |fa|
        f = Reports::FormAnswer.new(fa)
        rows << mapping.map do |m|
          f.call_method(m[:method])
        end
      end
    end

    as_csv(rows)
  end

  private

  def mapping
    MAPPING
  end
end
