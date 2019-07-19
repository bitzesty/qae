module PaasResolver
  module_function

  def redis_uri
    JSON.parse(ENV["VCAP_SERVICES"])["redis"][0]["credentials"]["uri"]
  rescue
    ENV["REDIS_URL"]
  end

  def pgsql_uri
    # TODO: !Important
    # need to fetch by service name if we use multiple elasticsearch services
    JSON.parse(ENV["VCAP_SERVICES"])["postgres"][0]["credentials"]["uri"]
  rescue
    ENV["DATABASE_URL"]
  end
end
