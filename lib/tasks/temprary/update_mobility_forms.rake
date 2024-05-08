namespace :db do
  desc "remove keys from appraisal forms no longer used"
  task remove_keys_from_mobility_assessor_assignments: :environment do

    mobility_appraisals = AssessorAssignment.joins(:form_answer)
      .where(award_year: AwardYear.find_by(year: 2017),
        position: [0, 1, 4],
        form_answers: {award_type: "mobility"},)

    appraisals_removed_keys = [
      "mobility_programme_benefit_desc",
      "mobility_programme_benefit_rate",
      "mobility_programme_benefit_the_organisation_desc",
      "mobility_programme_benefit_the_organisation_rate",
      "mobility_organisation_approach_desc",
      "mobility_organisation_approach_rate",
      "corporate_social_responsibility_desc",
      "corporate_social_responsibility_rate",
    ]

    mobility_appraisals.each do |entry|
      clean_doc = entry.document.reject { |key| key.in?(appraisals_removed_keys) }
      entry.document = clean_doc
      entry.save!(validate: false)
    end
  end
end
