# -*- coding: utf-8 -*-
class Eligibility::Trade < Eligibility
  AWARD_NAME = 'International Trade'

  validates :qae_for_trade_award_year,
            presence: true,
            if: proc { current_holder_of_qae_for_trade? && (!current_step || current_step == :qae_for_trade_award_year) }

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
            label: "Have you had substantial growth in overseas earnings in the last three years?",
            accept: :true,
            boolean: true,
            hint: "Substantial growth should be relative to your business size and sector.",
            if: proc { !skipped? }

  property :current_holder_of_qae_for_trade,
            label: "Are you a current holder of a Queen's Award for International Trade?",
            boolean: true,
            accept: :all,
            if: proc { account.basic_eligibility.current_holder == "yes" }

  # TODO: Hardcoded date
  property :qae_for_trade_award_year,
           values: %w(2015 2014 2013 2012 2011 2010 before_2010),
           accept: :not_nil_if_current_holder_of_qae_for_trade,
           label: "In which year did you receive the award?",
           if: proc { account.basic_eligibility.current_holder == "yes" && (current_holder_of_qae_for_trade.nil? || current_holder_of_qae_for_trade?) },
           allow_nil: true
end
