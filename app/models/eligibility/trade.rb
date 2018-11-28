# -*- coding: utf-8 -*-
class Eligibility::Trade < Eligibility
  AWARD_NAME = 'International Trade'

  validates :current_holder_of_qae_for_trade,
            presence: true,
            if: proc {
              (current_step == :current_holder_of_qae_for_trade || force_validate_now.present?) &&
                  current_holder_of_an_award?
            }, on: :update

  validates :qae_for_trade_award_year,
            presence: true,
            not_a_last_year_winner: true,
            if: proc {
              current_holder_of_an_award? &&
                  (current_step == :qae_for_trade_award_year || force_validate_now.present?) &&
                  current_holder_of_qae_for_trade?
            }, on: :update

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
           if: proc {!skipped?}

  property :growth_over_the_last_three_years,
           label: "Have you had significant growth in overseas earnings over the period of your entry (i.e. in the last 3 or 6 years)?",
           accept: :true,
           boolean: true,
           hint: "Significant growth should be relative to your business size and sector.",
           if: proc {!skipped?}

  property :current_holder_of_qae_for_trade,
           label: "Are you a current holder of a Queen's Award for International Trade?",
           boolean: true,
           accept: :all,
           if: proc {current_holder_of_an_award?}

  property :qae_for_trade_award_year,
           values: (AwardYear.current.year - 5..AwardYear.current.year - 1).to_a.reverse + ["before_#{AwardYear.current.year - 5}"],
           accept: :not_nil_if_current_holder_of_qae_for_trade,
           label: "In which year did you receive the award?",
           if: proc {current_holder_of_an_award? && current_holder_of_qae_for_trade?},
           allow_nil: true

  private

  def current_holder_of_an_award?
    account_holder_of_an_award? || application_holder_of_an_award?
  end

  def account_holder_of_an_award?
    account.basic_eligibility.current_holder == "yes"
  end

  def application_holder_of_an_award?
    form_answer &&
        form_answer.form_basic_eligibility.present? &&
        form_answer.form_basic_eligibility.current_holder == "yes"
  end
end
