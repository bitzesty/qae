class Eligibility::Trade::NotALastYearWinnerValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless self.class.valid_year?(value)
      record.errors.add(
        attribute,
        "Not eligible to apply this year",
      )
    end
  end

  # must not be winner last year
  def self.valid_year?(value)
    value.to_i < Date.current.year
  end
end
