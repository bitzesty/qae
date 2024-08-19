#
# DO NOT RUN IT ON LIVE!
# ITS for staging and dev only
#

namespace :db do
  desc "fix appraisal forms on dev and staging"
  task fix_sust_dev_apprailsal_forms_v: :environment do
    entries = AssessorAssignment.where(award_year_id: AwardYear.find_by(year: 2017), position: [0, 1, 4]).where.not(assessed_at: nil)

    development = entries.select { |e| e.form_answer.award_type == "development" }

    # Reject environment_rate, social_rate, economic_rate for development

    development.each do |entry|
      new_document = entry.document

      new_document.reject! do |k, v|
        k == "environment_rate" ||
          k == "social_rate" ||
          k == "economic_rate"
      end

      entry.document = new_document
      entry.save!(validate: false)
    end
  end
end
