# -*- coding: utf-8 -*-
class Eligibility::Trade < Eligibility
  AWARD_NAME = 'International Trade'

  validates :qae_for_trade_expiery_date, presence: true, if: proc { current_holder_of_qae_for_trade? && (!current_step || current_step == :qae_for_trade_expiery_date)  }

  property :sales_above_100_000_pounds, boolean: true, label: "Have you had £100,000 or more overseas sales in each of the last three years?", accept: :true
  property :any_dips_over_the_last_three_years, label: "Have you had any dips in your overseas sales over the last three years?", accept: :false, boolean: true, hint: "For this question a 'dip' is any annual drop in overseas sales."
  property :growth_over_the_last_three_years, label: "Have you had substantial growth in overseas earnings over the last three years?", accept: :true, boolean: true, hint: "Substantial growth' should be relative to your business size and sector."
  property :current_holder_of_qae_for_trade, label: "Are you a current holder of a Queen's Award for International Trade?", boolean: true, accept: :all
  property :qae_for_trade_expiery_date, values: %w(2015 2016 2017 2018 2019), accept: :not_nil_if_current_holder_of_qae_for_trade, label: 'When does your current award expire?', if: proc { current_holder_of_qae_for_trade.nil? || current_holder_of_qae_for_trade? }, allow_nil: true
end
