class AdvancedEmailValidator < ActiveModel::Validator
  def validate(record)
    parsed = Mail::Address.new(record.email)
    validate_address_domain(record, parsed) ||
      validate_address_well_formed(record, parsed)
  rescue Mail::Field::ParseError
    set_error(record)
  end

  def set_error(record)
    record.errors.add(:email, :invalid)
  end

  def maybe_set_error(record, message)
    yield.tap do |value|
      record.errors.add(:email, message: message) if value
    end
  end

  def validate_address_domain(record, parsed)
    maybe_set_error(record, "is not a valid address because it ends with a dot or starts with a dot") do
      parsed.domain.present? && (parsed.domain.end_with?(".") || parsed.domain.start_with?("."))
    end
  end

  def validate_address_well_formed(record, parsed)
    maybe_set_error(record, "is not a valid address") do
      not (parsed.local &&
           parsed.domain &&
           parsed.address == record.email &&
           parsed.local != record.email)
    end
  end
end
