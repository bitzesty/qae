# frozen_string_literal: true

module Utils
  class Diff
    def self.calc(v1, v2, abs: true)
      return nil unless ::Utils::String.integer?(v1) && ::Utils::String.integer?(v2)

      res = v1.to_i - v2.to_i
      abs ? res.abs : res
    rescue StandardError
      nil
    end
  end
end
