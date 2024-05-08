class Reports::AllEntries
  include Reports::CsvHelper

  MAPPING = [
    {
      label: "URN",
      method: :urn,
    },
    {
      label: "Category",
      method: :category,
    },
    # Head of business attributes
    {
      label: "Title",
      method: :head_title,
    },
    {
      label: "FirstName",
      method: :head_first_name,
    },
    {
      label: "Surname",
      method: :head_surname,
    },
    {
      label: "PersonalHonours",
      method: :personal_honours,
    },
    {
      label: "HeadOfUnitPosition",
      method: :head_position,
    },
    {
      label: "HeadOfUnitEmail",
      method: :head_of_business_email,
    },
    {
      label: "CompanyName",
      method: :company_or_nominee_name,
    },
    {
      label: "ContactTitle",
      method: :contact_title,
    },
    {
      label: "ContactFirstName",
      method: :contact_first_name,
    },
    {
      label: "ContactSurname",
      method: :contact_surname,
    },
    {
      label: "ContactPosition",
      method: :contact_position,
    },
    {
      label: "ContactEmail",
      method: :contact_email,
    },
    {
      label: "ContactTelephone",
      method: :contact_telephone,
    },
    {
      label: "Agreed To Data Sharing With Lord-Lieutenants?",
      method: :agree_sharing_of_details_with_lieutenancies?,
    },
    {
      label: "Innovation Type",
      method: :innovation_type,
    },
    {
      label: "Innovation Description",
      method: :innovation_description,
    },
    {
      label: "CaseSummaryOverallGrade",
      method: :case_summary_overall_grade,
    },
    {
      label: "Overall Status",
      method: :overall_status,
    },
    {
      label: "SICCode",
      method: :sic_code,
    },
    {
      label: "Employees",
      method: :employees,
    },
    {
      label: "GovernmentSupport",
      method: :government_support,
    },
    {
      label: "CompanyRegNo",
      method: :business_reg_no,
    },
    {
      label: "Address1",
      method: :principal_address1,
    },
    {
      label: "Address2",
      method: :principal_address2,
    },
    {
      label: "Address3",
      method: :principal_address3,
    },
    {
      label: "County",
      method: :principal_county,
    },
    {
      label: "Region",
      method: :business_region,
    },
    {
      label: "Postcode",
      method: :principal_postcode,
    },
    {
      label: "UnitWebsite",
      method: :unit_website,
    },
    {
      label: "ImmediateParentName",
      method: :immediate_parent_name,
    },
    {
      label: "ImmediateParentCountry",
      method: :immediate_parent_country,
    },
    {
      label: "OrganisationWithUltimateControl",
      method: :organisation_with_ultimate_control,
    },
    {
      label: "OrganisationWithUltimateControlCountry",
      method: :organisation_with_ultimate_control_country,
    },
    {
      label: "ProductService",
      method: :product_service,
    },
    {
      label: "FinalYearOverseasSales",
      method: :final_year_overseas_sales,
    },
    {
      label: "FinalYearTotalSales",
      method: :final_year_total_sales,
    },
    {
      label: "CurrentQueensAwardHolder",
      method: :current_queens_award_holder,
    },
    {
      label: "DateStartedTrading",
      method: :date_started_trading,
    },
    {
      label: "ExportMarkets",
      method: :export_markets,
    },
    {
      label: "NomineeTitle",
      method: :nominee_title,
    },
    {
      label: "NomineeFirstName",
      method: :nominee_first_name,
    },
    {
      label: "NomineeSurname",
      method: :nominee_surname,
    },
    {
      label: "NomineeEmail",
      method: :nominee_email,
    },
  ]

  def initialize(year)
    @year = year
  end

  def build
    scoped = @year.form_answers.includes(:award_year, :user)

    prepare_response(scoped, true)
  end

  def stream
    scoped = @year.form_answers.preload(:award_year, :user)

    prepare_stream(scoped, true)
  end

  private

  def mapping
    MAPPING
  end
end
