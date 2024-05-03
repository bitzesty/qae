class Eligibility::Trade::NotALastYearWinnerValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if self.class.valid_year?(value)

    record.errors.add(
      attribute,
      "Not eligible to apply this year",
    )
  end

  # must not be winner last year
  def self.valid_year?(value)
    value.to_i < Date.today.year
  end
end
