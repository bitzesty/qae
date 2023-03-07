class Reports::ReceptionBuckinghamPalaceReport
  include Reports::CSVHelper

  MAPPING = [
    {
      label: "Award / Category",
      method: :award_category
    },
    {
      label: "Organisation / Company (NOT included on envelope)",
      method: :organisation_company
    },
    {
      label: "Title",
      method: :title
    },
    {
      label: "First name",
      method: :first_name
    },
    {
      label: "Surname",
      method: :last_name
    },
    {
      label: "Job Title / Position",
      method: :job_name
    },
    {
      label: "Decorations / Post Nominals",
      method: :post_nominals
    },
    {
      label: "Address 1 (first line on envelope)",
      method: :address_1
    },
    {
      label: "Address 2",
      method: :address_2
    },
    {
      label: "Address 3",
      method: :address_3
    },
    {
      label: "Address 4",
      method: :address_4
    },
    {
      label: "Postcode",
      method: :postcode
    },
    {
      label: "Telephone number (if known)",
      method: :phone_number
    },
    {
      label: "Product or brief description",
      method: :product_description
    },
    {
      label: "Additional Information e.g. Wheelchair user",
      method: :additional_info
    },
    {
      label: "Previous years won",
      method: :previous_years_won
    },
    {
      label: "Royal Affiliation / Previous Links",
      method: :royal_family_connection_details
    }

  ]

  def initialize(year)
    @year = year
  end

  def build
    rows = []

    scope = PalaceAttendee.includes(palace_invite: :form_answer)
                          .where("form_answers.award_year_id = ?", @year.id)
                          .where("palace_invites.submitted = ?", true)
                          .order("palace_invites.form_answer_id ASC, palace_attendees.id ASC")

    scope.each do |attendee|
      attendee_pointer = Reports::PalaceAttendeePointer.new(attendee)

      rows << mapping.map do |m|
        attendee_pointer.call_method(m[:method])
      end
    end

    as_csv(rows)
  end

  def stream
    @_csv_enumerator ||= Enumerator.new do |yielder|
      yielder << CSV.generate_line(headers, encoding: "UTF-8", force_quotes: true)

      PalaceAttendee.includes(palace_invite: :form_answer)
                    .where(form_answers: { award_year_id: @year.id })
                    .where(palace_invites: { submitted: true })
                    .order("palace_invites.form_answer_id ASC, palace_attendees.id ASC").find_each do |attendee|
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

  def mapping
    MAPPING
  end
end
