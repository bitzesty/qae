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
      label: "PressContactName",
      method: :press_contact_name
    },
    {
      label: "PressContactTel",
      method: :press_contact_tel
    },
    {
      label: "PressContactEmail",
      method: :press_contact_email
    },
    {
      label: "PressBookNotes",
      method: :press_contact_notes
    },
    {
      label: "ApplicantSubmittedPressNote",
      method: :applicant_submitted_press_note
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
      label: "SIC code",
      method: :sic_code
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
      label: "Address4",
      method: :principal_address4
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
      label: "ImmediateParentName",
      method: :immediate_parent_name
    },
    {
      label: "ImmediateParentCountry",
      method: :immediate_parent_country
    },
    {
      label: "AssessorAgreedPressNote",
      method: :assessor_agreed_press_note
    },
    {
      label: "QAOAgreedPressNote",
      method: :qao_agreed_press_note
    },
    {
      label: "ConfirmedPalaceAttendees",
      method: :palace_invite_submitted
    }
  ]

  def initialize(year)
    @scope = year.form_answers.where(state: ["awarded", "recommended"]).order(:id).includes(:user, :palace_invite)
  end

  private

  def mapping
    MAPPING
  end
end
