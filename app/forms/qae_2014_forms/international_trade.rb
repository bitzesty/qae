require 'qae_2014_forms/international_trade/international_trade_step1'
require 'qae_2014_forms/international_trade/international_trade_step2'
require 'qae_2014_forms/international_trade/international_trade_step3'
require 'qae_2014_forms/international_trade/international_trade_step4'
require 'qae_2014_forms/international_trade/international_trade_step5'

class QAE2014Forms
  class << self
    def trade
      @trade ||= QAEFormBuilder.build 'Apply for the International Trade Award' do

        step 'Company Information', &QAE2014Forms.trade_step1

        step 'Commercial Performance', &QAE2014Forms.trade_step2

        step 'Description of Goods or Services', &QAE2014Forms.trade_step3

        step 'Declaration of Corporate Responsibility', &QAE2014Forms.trade_step4

        step 'Authorisation/Monitoring', &QAE2014Forms.trade_step5

      end
    end
  end
end
