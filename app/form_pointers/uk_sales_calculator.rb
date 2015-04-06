class UkSalesCalculator
  attr_reader :fetched_data

  def initialize(fetched_data)
    @fetched_data = fetched_data
  end

  def data
    exports = data_values(:exports)
    exports ||= data_values(:overseas_sales)
    total_turnover = data_values(:total_turnover)

    return [] if !exports || !total_turnover || exports.none? || total_turnover.none?

    calculated = []

    exports.length.times do |i|
      calculated << (total_turnover[i][:value].to_f - exports[i][:value].to_f).round(2)
    end

    { uk_sales: calculated }
  end

  private

  def data_values(key)
    values = fetched_data.detect { |d| d[key] }
    values && values[key]
  end
end
