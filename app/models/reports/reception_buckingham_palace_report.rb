class Reports::ReceptionBuckinghamPalaceReport
  include Reports::CsvHelper

  MAPPING = [
    {
      label: "Organisation / Company (NOT included on envelope)",
      method: :organisation_company,
    },
    {
      label: "Job Title / Position",
      method: :job_name,
    },
    {
      label: "Award / Category",
      method: :award_category,
    },
    {
      label: "Title",
      method: :title,
    },
    {
      label: "First name",
      method: :first_name,
    },
    {
      label: "Surname",
      method: :last_name,
    },
    {
      label: "Decorations / Post Nominals",
      method: :post_nominals,
    },
    {
      label: "Address 1 (first line on envelope)",
      method: :address_1,
    },
    {
      label: "Address 2",
      method: :address_2,
    },
    {
      label: "City or town",
      method: :address_3,
    },
    {
      label: "County",
      method: :address_4,
    },
    {
      label: "Postcode",
      method: :postcode,
    },
    {
      label: "Dietary needs",
      method: :dietary_requirements,
    },
    {
      label: "Disabled access required",
      method: :disabled_access,
    },
    {
      label: "Accessibility details (for example, wheelchair user or person hard of hearing)",
      method: :additional_info,
    },
    {
      label: "Telephone number (if known)",
      method: :phone_number,
    },
    {
      label: "Royal Affiliation / Previous Links",
      method: :royal_family_connection_details,
    },
    {
      label: "Product or brief description",
      method: :product_description,
    },
    {
      label: "Previous years won",
      method: :previous_years_won,
    },
  ]

  def initialize(year)
    @year = year
  end

  def build
    prepare_response(scoped_collection, false, Reports::PalaceAttendeePointer)
  end

  def stream
    @_csv_enumerator ||= Enumerator.new do |yielder|
      yielder << CSV.generate_line(headers, encoding: "UTF-8", force_quotes: true)

      scoped_collection.find_each do |attendee|
        attendee_pointer = Reports::PalaceAttendeePointer.new(attendee)

        row = mapping.map do |m|
          raw = attendee_pointer.call_method(m[:method])
          Utils::String.sanitize(raw)
        end

        yielder << CSV.generate_line(row, encoding: "UTF-8", force_quotes: true)
      end
    end
  end

  private

  def scoped_collection
    PalaceAttendee.includes(palace_invite: :form_answer)
                  .where("form_answers.award_year_id = ?", @year.id)
                  .where("palace_invites.submitted = ?", true)
                  .order("palace_invites.form_answer_id ASC, palace_attendees.id ASC")
  end

  def mapping
    MAPPING
  end
end
