# frozen_string_literal: true

module Utils
  class Date
    def self.within_range?(value, range)
      return false if value.blank?
      return false unless range.is_a?(Range)

      date = case value
      when ::Date, ::DateTime then value.to_date
      when ::String then ::Date.parse(value)
      end
      min, max = range.minmax

      return date >= min && date <= max
    rescue
      false
    end

    def self.valid?(date, separator: "/")
      case date
      when ::Date, ::DateTime
        true
      when ::String
        parts = date.split(separator).map(&:to_i)
        ::Date.valid_date?(*parts) || ::Date.valid_date?(*parts.reverse)
      when ::Array
        parts = date.map(&:to_i)
        ::Date.valid_date?(*parts) || ::Date.valid_date?(*parts.reverse)
      else
        false
      end
    rescue
      false
    end
  end
end
