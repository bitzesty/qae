class Reports::DiscrepanciesBetweenPrimaryAndSecondaryAppraisals
  include Reports::CSVHelper

  MAPPING = [
    {
      label: "URN",
      method: :urn
    },
    {
      label: "Primary Assessor Name",
      method: :primary_assessor_name
    },
    {
      label: "Primary Assessor Email",
      method: :primary_assessor_email
    },
    {
      label: "Primary Assessor Submitted At",
      method: :primary_assessor_submitted_at
    },
    {
      label: "Secondary Assessor Name",
      method: :secondary_assessor_name
    },
    {
      label: "Secondary Assessor Email",
      method: :secondary_assessor_email
    },
    {
      label: "Secondary Assessor Submitted At",
      method: :secondary_assessor_submitted_at
    },
    {
      label: "Discrepancies (Primary - Secondary)",
      method: :discrepancies_between_primary_and_secondary_appraisals_details
    }
  ]

  def initialize(year, award_type, current_subject=nil)
    @year = year
    @award_type = award_type

    if current_subject.is_a?(Assessor) &&
      !current_subject.lead_roles.include?(@award_type)

      raise "Access Denied!"
    end
  end

  def stream
    @_csv_enumerator ||= Enumerator.new do |yielder|
      yielder << CSV.generate_line(headers, encoding: "UTF-8", force_quotes: true)

      @year.form_answers.order(:id)
                        .joins(%Q{
                          JOIN assessor_assignments primary_assignments ON primary_assignments.form_answer_id = form_answers.id
                          JOIN assessor_assignments secondary_assignments ON secondary_assignments.form_answer_id = form_answers.id
                        })
                        .where(primary_assignments: { position: AssessorAssignment.positions[:primary] })
                        .where.not(primary_assignments: { position: nil })
                        .where(secondary_assignments: { position: AssessorAssignment.positions[:secondary] })
                        .where.not(secondary_assignments: { position: nil })
                        .primary_and_secondary_appraisals_are_not_match
                        .where(award_type: @award_type).find_each do |fa|
        f = Reports::FormAnswer.new(fa)

        row = mapping.map do |m|
          raw = f.call_method(m[:method])
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
