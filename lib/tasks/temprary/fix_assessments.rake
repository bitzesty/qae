#
# DO NOT RUN IT ON LIVE!
# ITS for staging and dev only
#

namespace :db do
  desc "fix wrong assessments on dev and staging"
  task fix_wrong_assessments_on_dev_and_staging: :environment do
    entries = AssessorAssignment.where(award_year_id: AwardYear.find_by(year: 2017), position: [0,1,4]).where("assessed_at IS NOT NULL")

    # Move strategy to "corporate_social_responsibility"
    # and remove strategy as these award types should not have strategy
    #
    without_strategy = entries.select { |e| e.form_answer.award_type == "innovation" || e.form_answer.award_type == "mobility" || e.form_answer.award_type == "development" }

    without_strategy.each do |entry|
      strategy_desc = entry.document["strategy_desc"]
      strategy_rate = entry.document["strategy_rate"]

      new_document = entry.document

      new_document["corporate_social_responsibility_desc"] = strategy_desc
      new_document["corporate_social_responsibility_rate"] = strategy_rate
      new_document.reject! { |k, v| k == "strategy_desc" || k == "strategy_rate" }

      entry.document = new_document
      entry.save!(validate: false)
    end

    # Move strategy to "corporate_social_responsibility"
    #
    trade = entries.select { |e| e.form_answer.award_type == "trade" }

    trade.each do |entry|
      strategy_desc = entry.document["strategy_desc"]
      strategy_rate = entry.document["strategy_rate"]

      entry.document["corporate_social_responsibility_desc"] = strategy_desc
      entry.document["corporate_social_responsibility_rate"] = strategy_rate

      entry.save!(validate: false)
    end
  end

  desc "fix appraisal forms on dev and staging"
  task fix_staging_dev_apprailsal_forms: :environment do
    entries = AssessorAssignment.where(award_year_id: AwardYear.find_by(year: 2017), position: [0,1,4]).where("assessed_at IS NOT NULL")

    # Reject strategy for development

    development = entries.select { |e| e.form_answer.award_type == "development" }

    development.each do |entry|
      new_document = entry.document
      new_document.reject! { |k, v| k == "strategy_desc" || k == "strategy_rate" }

      entry.document = new_document
      entry.save!(validate: false)
    end
  end

  desc "fix staging and dev sust dev assessments"
  task fix_staging_dev_sust_dev_assessments: :environment do
    entries = AssessorAssignment.where(award_year_id: AwardYear.find_by(year: 2017)).select { |a| a.document != {} }

    # Reject keys from development

    keys_to_remove = [
      "environment_protection",
      "benefiting_the_wilder_community",
      "sustainable_resource",
      "economic_sustainability",
      "supporting_employees",
      "internal_leadership",
      "industry_sector",
    ]

    development = entries.select { |e| e.form_answer.award_type == "development" }

    development.each do |entry|
      new_document = entry.document

      keys_to_remove.each do |key|
        new_document.reject! { |k, v| k == "#{key}_desc" || k == "#{key}_rate" }
      end

      entry.document = new_document
      entry.save!(validate: false)

      form = entry.form_answer
      feedback = form.feedback

      if feedback.present?
        f_doc = feedback.document

        keys_to_remove.each do |key|
          f_doc.reject! { |k, v| k == "#{key}_desc" || k == "#{key}_rate" }
        end

        feedback.document = f_doc
        feedback.save!(validate: false)
      end
    end
  end
end
