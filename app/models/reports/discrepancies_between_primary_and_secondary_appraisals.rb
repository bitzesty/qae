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
      label: "Discrepancies",
      method: :discrepancies_between_primary_and_secondary_appraisals_details
    }
  ]

  def initialize(year, current_subject=nil)
    @scope = year.form_answers
                 .order(:id)
                 .joins(
      "JOIN assessor_assignments primary_assignments ON primary_assignments.form_answer_id=form_answers.id"
    ).joins(
      "JOIN assessor_assignments secondary_assignments ON secondary_assignments.form_answer_id=form_answers.id"
    ).where(
      "primary_assignments.position = ? AND primary_assignments.submitted_at IS NOT NULL", AssessorAssignment.positions[:primary]
    ).where(
      "secondary_assignments.position = ? AND secondary_assignments.submitted_at IS NOT NULL", AssessorAssignment.positions[:secondary]
    ).primary_and_secondary_appraisals_are_not_match

    if current_subject.is_a?(Assessor)
      @scope = @scope.where(award_type: current_subject.lead_roles)
    end

    @scope
  end

  private

    def mapping
      MAPPING
    end
end