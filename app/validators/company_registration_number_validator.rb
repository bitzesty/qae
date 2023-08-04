# frozen_string_literal: true

# Based on: https://gist.github.com/rob-murray/01d43581114a6b319034732bcbda29e1

class CompanyRegistrationNumberValidator < ActiveModel::EachValidator
  VALID_CRN_REGEX = %r{\A(?!.{9})((AC|ZC|FC|GE|LP|OC|SE|SA|SZ|SF|GS|SL|SO|SC|ES|NA|NZ|NF|GN|NL|NC|R0|NI|EN|\d{0,2}|SG|FE)\d{5}(\d|C|R))|((RS|SO)\d{3}(\d{3}|\d{2}[WSRCZF]|\d(FI|RS|SA|IP|US|EN|AS)|CUS))|((NI|SL)\d{5}[\dA])|(OC(([\dP]{5}[CWERTB])|([\dP]{4}(OC|CU))))\z}i.freeze

  def self.regexp
    VALID_CRN_REGEX
  end

  def self.valid?(value)
    !!(value =~ regexp)
  end

  def validate_each(record, attribute, value)
    return if options[:allow_nil] && value.nil?
    return if options[:allow_blank] && value.blank?
    return if options[:allow_empty] && value == ""
    unless self.class.valid?(value)
      record.errors.add(attribute, message: options[:message] || "is not a valid company registration number")
    end
  end
end
