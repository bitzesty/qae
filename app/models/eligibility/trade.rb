# -*- coding: utf-8 -*-
class Eligibility::Trade < Eligibility
  AWARD_NAME = 'The International Trade Award'

  validates :qae_for_trade_expiery_date, presence: true, if: :current_holder_of_qae_for_trade?

  property :sales_above_100_000_pounds, boolean: true, label: "Have you had £100,000 or more overseas sales in each of the last three years?", accept: :true
  property :any_dips_over_the_last_three_years, label: "Have you had any dips in your overseas sales over the last three years?", accept: :true, boolean: true
  property :current_holder_of_qae_for_trade, label: "Are you a current holder of a Queen's Award for International Trade?", boolean: true, accept: :all
  property :qae_for_trade_expiery_date, values: %w(2015 2016 2017 2018 2019), accept: :not_nil_if_current_holder_of_qae_for_trade, label: 'When does it expire?', hidden: true, allow_nil: true
end
