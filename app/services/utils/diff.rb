# frozen_string_literal: true

module Utils
  class Diff
    def self.calc(v1, v2)
      return nil unless ::Utils::String.integer?(v1) && ::Utils::String.integer?(v2)

      (v1.to_i - v2.to_i).abs
    rescue
      nil
    end
  end
end
