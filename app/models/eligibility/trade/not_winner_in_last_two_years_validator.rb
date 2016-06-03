class Eligibility::Trade::NotWinnerInLastTwoYearsValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(
      attribute,
      "Not eligible to apply this year"
    ) unless self.class.valid_year?(value)
  end

  ##
  # must not be winner of last 2 years
  def self.valid_year?(value)
    value.to_i < (Date.today.year - 1)
  end
end
