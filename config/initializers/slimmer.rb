Qae::Application.configure do
  config.slimmer.logger = Rails.logger

  if Rails.env.production?
    config.slimmer.use_cache = true
  end

  if Rails.env.development? || Rails.env.test?
    config.slimmer.asset_host = ENV["STATIC_DEV"] || "http://127.0.0.1:3013"
  end
end
