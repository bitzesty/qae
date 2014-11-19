Qae::Application.configure do
  config.slimmer.logger = Rails.logger

  if Rails.env.production?
    config.slimmer.use_cache = true
  end

  config.slimmer.asset_host = ENV["STATIC_DEV"] || "https://assets.digital.cabinet-office.gov.uk/"
end
