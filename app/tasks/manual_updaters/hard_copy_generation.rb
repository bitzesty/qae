#
# Usefull snippet in case if need
# to run or debug hard copy PDF generation of
# Case Summaries or Feedbacks
#
# ManualUpdaters::HardCopyGeneration.case_summary_individual
#
# AwardYear.find_by(year: 2016).check_hard_copy_pdf_generation_status!("case_summary")
#
# ManualUpdaters::HardCopyGeneration.feedback_individual
#
# AwardYear.find_by(year: 2016).check_hard_copy_pdf_generation_status!("feedback")
#
# ManualUpdaters::HardCopyGeneration.case_summary_aggregated
#
# AwardYear.find_by(year: 2016).check_aggregated_hard_copy_pdf_generation_status!("case_summary")
#
# ManualUpdaters::HardCopyGeneration.feedback_aggregated
#
# AwardYear.find_by(year: 2016).check_aggregated_hard_copy_pdf_generation_status!("feedback")
#

#
# To clean up use (NOTE: never run it on live!!!)
#

# CaseSummaryHardCopyPdf.destroy_all
# FeedbackHardCopyPdf.destroy_all
# AggregatedAwardYearPdf.destroy_all

# award_year = AwardYear.find_by(year: 2016)
# award_year.case_summary_hard_copies_state = nil
# award_year.feedback_hard_copies_state = nil
# award_year.aggregated_case_summary_hard_copy_state = nil
# award_year.aggregated_feedback_hard_copy_state = nil

# award_year.save!(validate: false)
#

module ManualUpdaters
  class HardCopyGeneration
    class << self
      def case_summary_individual
        year = AwardYear.find_by(year: 2016)
        year.update_column(:case_summary_hard_copies_state, "started")

        not_updated_entries_cs_individual = []

        year.hard_copy_case_summary_scope.find_each do |form_answer|
          form_answer.generate_case_summary_hard_copy_pdf!

          sleep 3

          logy "[#{ENV["MAILER_HOST"]} | CS IND | #{form_answer.id}] -------------------------------- updated"
        rescue => e
          not_updated_entries_cs_individual << form_answer.id

        logy "[#{ENV["MAILER_HOST"]} | CS IND | #{form_answer.id} | ERROR] --------------------------------- #{e.message}"
        end

        if not_updated_entries_cs_individual.present?
          logy "[#{ENV["MAILER_HOST"]} | CS IND | errored #{not_updated_entries_cs_individual.count}] ------------ #{not_updated_entries_cs_individual.inspect}"
        end

        if year.check_hard_copy_pdf_generation_status!("case_summary")
          logy "[#{ENV["MAILER_HOST"]} | CS IND] -------------- DONE SUCCESSFULY!"
        else
          stats = year.hard_copy_case_summary_scope.count.count
          updated_stats = year.hard_copy_case_summary_scope.hard_copy_generated("case_summary").count.count

          logy "[#{ENV["MAILER_HOST"]} | CS IND | ERRORS] -------------- STATS DIDN'T MATCH!"
          logy "[#{ENV["MAILER_HOST"]} | CS IND | ERRORS] -------------- scope: #{stats} | updated_scope: #{updated_stats}"
        end
      end

      def feedback_individual
        year = AwardYear.find_by(year: 2016)
        year.update_column(:feedback_hard_copies_state, "started")

        not_updated_entries_feed_individual = []

        year.hard_copy_feedback_scope.find_each do |form_answer|
          form_answer.generate_feedback_hard_copy_pdf!

          sleep 3

          logy "[#{ENV["MAILER_HOST"]} | FEED IND | #{form_answer.id}] -------------------------------- updated"
        rescue => e
          not_updated_entries_feed_individual << form_answer.id

        logy "[#{ENV["MAILER_HOST"]} | FEED IND | #{form_answer.id} | ERROR] --------------------------------- #{e.message}"
        end

        if not_updated_entries_feed_individual.present?
          logy "[#{ENV["MAILER_HOST"]} | FEED IND | errored #{not_updated_entries_feed_individual.count}] ------------ #{not_updated_entries_feed_individual.inspect}"
        end

        if year.check_hard_copy_pdf_generation_status!("feedback")
          logy "[#{ENV["MAILER_HOST"]} | FEED IND] -------------- DONE SUCCESSFULY! STATS MATCHES!"
        else
          stats = year.hard_copy_feedback_scope.count.count
          updated_stats = year.hard_copy_feedback_scope.hard_copy_generated("feedback").count.count

          logy "[#{ENV["MAILER_HOST"]} | FEED IND | ERRORS] -------------- STATS DIDN'T MATCH!"
          logy "[#{ENV["MAILER_HOST"]} | FEED IND | ERRORS] -------------- scope: #{stats} | updated_scope: #{updated_stats}"
        end
      end

      def case_summary_aggregated
        year = AwardYear.find_by(year: 2016)
        year.update_column(:aggregated_case_summary_hard_copy_state, "started")

        FormAnswer::POSSIBLE_AWARDS.each do |award_category|
          HardCopyGenerators::AggregatedCaseSummaryGenerator.new(award_category, year, "case_summary").run
        end

        year.reload.check_aggregated_hard_copy_pdf_generation_status!("case_summary")
      end

      def feedback_aggregated
        year = AwardYear.find_by(year: 2016)
        year.update_column(:aggregated_feedback_hard_copy_state, "started")

        FormAnswer::POSSIBLE_AWARDS.each do |award_category|
          HardCopyGenerators::AggregatedFeedbackGenerator.new(award_category, year, "feedback").run
        end

        year.reload.check_aggregated_hard_copy_pdf_generation_status!("feedback")
      end

      def logy(m)
        puts m
        Rails.logger.info m
      end
    end
  end
end
