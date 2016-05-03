# -*- coding: utf-8 -*-
class Eligibility::Trade < Eligibility
  AWARD_NAME = 'International Trade'

  # validates :current_holder_of_qae_for_trade,
  #           presence: true,
  #           if: proc {
  #             account.basic_eligibility.try(:current_holder) == "yes" && (
  #               current_step == :current_holder_of_qae_for_trade ||
  #               current_step.blank?
  #             )
  #           }

  validates :qae_for_trade_award_year,
            presence: true,
            not_winner_in_last_year: true,
            if: proc {
              account.basic_eligibility.try(:current_holder) == "yes" &&
              current_holder_of_qae_for_trade? && (
                current_step == :qae_for_trade_award_year ||
                current_step.blank?
              )
            }

  property :sales_above_100_000_pounds,
            values: %w[yes no skip],
            label: "Have you made a minimum of £100,000 in overseas sales in each year of your entry (i.e. in the last 3 or 6 years)?",
            accept: :true,
            acts_like_boolean: true

  property :any_dips_over_the_last_three_years,
            label: "Have you had any dips in your overseas sales over the period of your entry (i.e. in the last 3 or 6 years)?",
            accept: :false,
            boolean: true,
            hint: "For this question a 'dip' is any annual drop in overseas sales.",
            if: proc { !skipped? }

  property :growth_over_the_last_three_years,
            label: "Have you had significant growth in overseas earnings over the period of your entry (i.e. in the last 3 or 6 years)?",
            accept: :true,
            boolean: true,
            hint: "Significant growth should be relative to your business size and sector.",
            if: proc { !skipped? }

  property :current_holder_of_qae_for_trade,
            label: "Are you a current holder of a Queen's Award for International Trade?",
            boolean: true,
            accept: :all,
            if: proc { account.basic_eligibility.current_holder == "yes" || (form_answer && form_answer.form_basic_eligibility.current_holder == "yes") }

  property :qae_for_trade_award_year,
           values: (AwardYear.current.year - 5..AwardYear.current.year - 1).to_a.reverse + ["before_#{AwardYear.current.year - 5}"],
           accept: :not_nil_if_current_holder_of_qae_for_trade,
           label: "In which year did you receive the award?",
           if: proc { account.basic_eligibility.current_holder == "yes" && current_holder_of_qae_for_trade? },
           allow_nil: true
end
