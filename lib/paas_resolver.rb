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

  def s3_config
    creds = s3_credentials

    {
      provider: 'AWS',
      aws_access_key_id: creds["aws_access_key_id"],
      aws_secret_access_key: creds["aws_secret_access_key"],
      region: creds["aws_region"]
    }
  rescue
    {
      provider: 'AWS',
      aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"],
      aws_secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
      region: ENV["AWS_REGION"]
    }
  end

  def s3_bucket
    s3_credentials["bucket_name"]
  rescue
    ENV["AWS_S3_BUCKET_NAME"]
  end

  def s3_credentials
    buckets = JSON.parse(ENV["VCAP_SERVICES"])["aws-s3-bucket"]
    bucket = buckets.detect { |b| b["instance_name"] == "uploadsbucket" }
    bucket["credentials"]
  end
end
