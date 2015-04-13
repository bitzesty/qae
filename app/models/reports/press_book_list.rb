require "csv"

class Reports::PressBookList
  MAPPING = [
    {
      label: "URN",
      method: :urn
    },
    {
      label: "Category"
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
      method: :region
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
      method: :address1
    },
    {
      label: "Address2",
      method: :address2
    },
    {
      label: "Address3",
      method: :address3
    },
    {
      label: "Postcode",
      method: :postcode
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
end
