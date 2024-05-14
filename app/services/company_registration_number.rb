# frozen_string_literal: true

class CompanyRegistrationNumber
  COMPANY_REGISTRATION_NUMBER_REGEX = %r{(?!\s)((AC|ZC|FC|GE|LP|OC|SE|SA|SZ|SF|GS|SL|SO|SC|ES|NA|NZ|NF|GN|NL|NC|R0|NI|EN|\d{0,2}|SG|FE(\s?))\d{5}(\d|C|R))|((RS|SO)\d{3}(\d{3}|\d{2}[WSRCZF]|\d(FI|RS|SA|IP|US|EN|AS)|CUS))|((NI|SL)\d{5}[\dA])|(OC(([\dP]{5}[CWERTB])|([\dP]{4}(OC|CU))))}i

  def self.extract_from(content)
    new(content).extract
  end

  attr_reader :content, :sanitizer

  def initialize(content)
    @sanitizer ||= Rails::Html::FullSanitizer.new
    @content = content.to_s
  end

  def extract
    return [] if content.blank?

    sanitized = sanitize(content).strip
    parts = tokenize(sanitized)
    parts.each_with_object([]) do |part, memo|
      memo << part if COMPANY_REGISTRATION_NUMBER_REGEX.match?(part)
    end
  end

  private

  def sanitize(value)
    sanitizer.sanitize(value)
  end

  def tokenize(value)
    value
      .remove(/(\(|\[).*(\)|\])/)
      .scan(/[[:word:]]*/i)
      .reject(&:blank?)
  end
end
