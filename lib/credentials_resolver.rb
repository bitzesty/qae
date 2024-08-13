module CredentialsResolver
  module_function

  def redis_uri
    ENV["REDIS_ENDPOINT"].presence || JSON.parse(ENV["VCAP_SERVICES"])["redis"][0]["credentials"]["uri"]
  rescue
    ENV["REDIS_URL"]
  end

  def pgsql_uri
    if ENV["DATABASE_CREDENTIALS"].present?
      parse_database_config(ENV["DATABASE_CREDENTIALS"])
    else
      # Fallback to the original logic
      JSON.parse(ENV["VCAP_SERVICES"])["postgres"][0]["credentials"]["uri"]
    end
  rescue
    ENV["DATABASE_URL"]
  end

  def parse_database_config(config_json)
    config = JSON.parse(config_json)

    # Construct the database URI
    "#{config["engine"]}://#{config["username"]}:#{config["password"]}@#{config["host"]}:#{config["port"]}/#{config["dbname"]}"
  end
end
