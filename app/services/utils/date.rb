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

      return date.in?(range)
    rescue
      false
    end
  end
end
