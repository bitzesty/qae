module PaasResolver
  module_function

  def redis_uri
    JSON.parse(ENV.fetch("VCAP_SERVICES", nil))["redis"][0]["credentials"]["uri"]
  rescue StandardError
    ENV.fetch("REDIS_URL", nil)
  end

  def pgsql_uri
    # TODO: !Important
    # need to fetch by service name if we use multiple elasticsearch services
    JSON.parse(ENV.fetch("VCAP_SERVICES", nil))["postgres"][0]["credentials"]["uri"]
  rescue StandardError
    ENV.fetch("DATABASE_URL", nil)
  end
end
