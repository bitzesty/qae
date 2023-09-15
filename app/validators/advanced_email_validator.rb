require 'resolv'

class AdvancedEmailValidator < ActiveModel::Validator
  def validate(record)
    parsed = Mail::Address.new(record.email)
    validate_address_domain(record, parsed) ||
      validate_address_well_formed(record, parsed)
      # https://trello.com/c/Jf9PoWrZ/1117-qae0820-support-disable-sendgrid-email-check
      # Disabling sendgrid vadidation due to errors with it
      # validate_dns_records(record, parsed)
      # validate_spam_reporter(record, parsed) ||
      # validate_bounced(record, parsed) # ||
      #validates_with_mailgun(record)
  rescue Mail::Field::ParseError
    set_error(record)
  end

  def has_mx_records(domain)
    Resolv::DNS.new.getresource(domain, Resolv::DNS::Resource::IN::MX)
  rescue Resolv::ResolvError
    false
  rescue Resolv::ResolvTimeout
    true
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
      parsed.domain.present? && (parsed.domain.end_with?('.') || parsed.domain.start_with?('.'))
    end
  end

  def validate_spam_reporter(record, parsed)
    maybe_set_error(record, "cannot receive messages from this system") do
      SendgridHelper.spam_reported?(parsed.address)
    end
  end

  def validate_bounced(record, parsed)
    maybe_set_error(record, "cannot receive messages from this system") do
      SendgridHelper.bounced?(parsed.address)
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

  def validate_dns_records(record, parsed)
    maybe_set_error(record, "SENDGRID: does not appear to be valid") do
      not has_mx_records(parsed.domain)
    end
  end

  def validates_with_mailgun(record)
    maybe_set_error(record, "MAILGUN: does not appear to be valid") do
      MailgunHelper.email_invalid?(record.email)
    end
  end
end
