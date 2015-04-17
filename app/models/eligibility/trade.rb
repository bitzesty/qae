# -*- coding: utf-8 -*-
class Eligibility::Trade < Eligibility
  AWARD_NAME = 'International Trade'

  validates :qae_for_trade_expiery_date,
            presence: true,
            if: proc { current_holder_of_qae_for_trade? && (!current_step || current_step == :qae_for_trade_expiery_date)  }

  property :sales_above_100_000_pounds,
            values: %w[yes no skip],
            label: "Have you made a minimum of £100,000 in overseas sales in each year of your entry (i.e. in the last 3 or 6 years)?",
            accept: :true,
            acts_like_boolean: true

  # REMOVE
  # property :direct_overseas_100_000_pounds,
  #           boolean: true,
  #           values: %w[yes no],
  #           label: "Was at least £100,000 of this direct overseas sales?",
  #           accept: :not_nil,
  #           hint: "Direct overseas sales are as a result of an organisation making a commitment to market overseas on its own behalf - and not through an intermediary."

  # property :organisation_fulfill_above_exceptions,
  #           values: %w[yes no],
  #           label: "Do your organisation fulfill any of the exceptions above?",
  #           accept: :true,
  #           acts_like_boolean: true,
  #           if: proc { !direct_overseas_100_000_pounds? }
  # REMOVE

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
  property :qae_for_trade_expiery_date,
            values: %w(2015 2016 2017 2018 2019),
            accept: :not_nil_if_current_holder_of_qae_for_trade,
            label: 'When does your current award expire?',
            if: proc { account.basic_eligibility.current_holder == "yes" && (current_holder_of_qae_for_trade.nil? || current_holder_of_qae_for_trade?) },
            allow_nil: true
end
