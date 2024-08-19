if Rails.env.development? && ENV["PROFILE_MODE"].to_s == "true"
  require "rack-mini-profiler"

  # initialization is skipped so trigger it
  Rack::MiniProfilerRails.initialize!(Rails.application)
end
