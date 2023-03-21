# frozen_string_literal: true

module Utils
  class String
    def self.sanitize(string)
      return "" if string.blank?

      string.to_s.tr("\n", "").squish
    end
  end
end
