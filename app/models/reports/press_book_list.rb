class Reports::PressBookList
  include Reports::CSVHelper

  MAPPING = [
    {
      label: "URN",
      method: :urn
    },
    {
      label: "Category",
      method: :category
    },
    {
      label: "CompanyName",
      method: :company_or_nominee_name
    },
    {
      label: "PressContactName"
    },
    {
      label: "PressContactTel"
    },
    {
      label: "PressContactEmail"
    },
    {
      label: "PressBookNotes"
    },
    {
      label: "CustomerAcceptedPressNote"
    },
    {
      label: "HeadOfUnit",
      method: :head_full_name
    },
    {
      label: "HeadOfUnitPosition",
      method: :head_position
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
      label: "BusinessSector",
      method: :business_sector
    },
    {
      label: "BusinessSectorOther",
      method: :business_sector_other
    },
    {
      label: "Address1",
      method: :principal_address1
    },
    {
      label: "Address2",
      method: :principal_address2
    },
    {
      label: "Address3",
      method: :principal_address3
    },
    {
      label: "Postcode",
      method: :principal_postcode
    },
    {
      label: "UnitWebsite",
      method: :unit_website
    },
    {
      label: "ImmediateParent",
      method: :immediate_parent
    },
    {
      label: "ImmediateParentCountry",
      method: :immediate_parent_country
    },
    {
      label: "QAEAgreedPressNote",
      method: :qao_agreed_press_note
    }
  ]

  def initialize(year)
    @scope = ::FormAnswer.all#.where(award_year_id: year.id, state: ["awarded", "recommended"]).includes(:user)
  end

  private

  def mapping
    MAPPING
  end
end
