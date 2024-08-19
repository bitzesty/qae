class ManualUpdaters::TradeAwardDowngrader
  attr_reader :form_answer

  def initialize(form_answer)
    @form_answer = form_answer
  end

  def run!
    raise ArgumentError, "You must provide an application" unless form_answer
    raise ArgumentError, "You must provide trade application" unless form_answer.trade?

    document = form_answer.document.dup

    raise ArgumentError, "Application is already 3 to 5 years" if document["trade_commercial_success"] != "6 plus"

    Rails.logger.debug "Downgrading Trade Application ##{form_answer.id}"

    # financial year changed dates
    %w[day month].each do |attr|
      # two times since the last date is already set
      2.times do |i|
        document["financial_year_changed_dates_#{i + 1}of3#{attr}"] = document["financial_year_changed_dates_#{i + 4}of6#{attr}"]
      end
    end

    %w[employees overseas_sales total_turnover net_profit].each do |attr|
      3.times do |i|
        document["#{attr}_#{i + 1}of3"] = document["#{attr}_#{i + 4}of6"]
      end
    end

    document["trade_commercial_success"] = "3 to 5"

    form_answer.document = document
    form_answer.save!

    Rails.logger.debug "Sucess!"
  end
end
