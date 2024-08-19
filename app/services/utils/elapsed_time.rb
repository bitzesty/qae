# frozen_string_literal: true

module Utils
  class ElapsedTime
    @clock = if Rack::Utils.respond_to?(:clock_time)
      -> { Rack::Utils.clock_time }
    else
      -> { Time.current }
    end.freeze

    def self.call
      @clock.call
    end
  end
end
