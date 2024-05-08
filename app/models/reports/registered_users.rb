class Reports::RegisteredUsers
  include Reports::CsvHelper

  MAPPING = [
    {
      label: "URN",
      method: :urn,
    },
    {
      label: "ApplicantName",
      method: :company_or_nominee_name,
    },
    {
      label: "RegisteredUserId",
      method: :user_id,
    },
    {
      label: "RegisteredUserTitle",
      method: :contact_title,
    },
    {
      label: "RegisteredUserFirstname",
      method: :contact_first_name,
    },
    {
      label: "RegisteredUserSurname",
      method: :contact_surname,
    },
    {
      label: "RegisteredUserEmail",
      method: :contact_email,
    },
    {
      label: "RegisteredUserTelephone",
      method: :contact_telephone,
    },
    {
      label: "RegisteredUserCompany",
      method: :company_name,
    },
    {
      label: "FormType",
      method: :award_type,
    },
    {
      label: "PercentageComplete",
      method: :percentage_complete,
    },
    {
      label: "Section A",
      method: :section1,
    },
    {
      label: "Section B",
      method: :section2,
    },
    {
      label: "Section C",
      method: :section3,
    },
    {
      label: "Section D",
      method: :section4,
    },
    {
      label: "Section E",
      method: :section5,
    },
    {
      label: "Section F",
      method: :section6,
    },
    {
      label: "Created",
      method: :created_at,
    },
    {
      label: "UserCreationDate",
      method: :user_creation_date,
    },
    {
      label: "SIC code",
      method: :sic_code,
    },
    {
      label: "Region",
      method: :business_region,
    },
    {
      label: "Employees",
      method: :employees,
    },
    {
      label: "KAOPermission",
      method: :qao_permission,
    },
    {
      label: "HowDidYouHearAboutKA",
      method: :qae_info_source,
    },
    {
      label: "HowDidYouHearAboutKAOther",
      method: :qae_info_source_other,
    }
  ]

  def initialize(year)
    @year = year
  end

  def build
    prepare_response(scoped_collection)
  end

  def stream
    prepare_stream(scoped_collection)
  end

  private

  def scoped_collection
    @year.form_answers.preload(:user,
      :assessor_assignments,
      :primary_assessor,
      :secondary_assessor,
      :form_answer_progress,)
  end

  def mapping
    MAPPING
  end
end
